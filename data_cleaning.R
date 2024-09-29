cat("**This code is to clean data from IBAMA on wildlife trafficking**")
cat("IBAMA is a federal agency of brazil (Brazilian Institute of Environment and Renewable Natural Resources")

# Load Libraries ----------------------------------------------------------
library(tidyverse)
library(janitor)

# Load Data ---------------------------------------------------------------
cat("From: https://dadosabertos.ibama.gov.br/dataset/fiscalizacao-auto-de-infracao")

cat("**Species affected**")
if (file.exists("./data_raw/especime.csv")) {
  espec <- read_delim("./data_raw/especime.csv", delim = ";")
} else {
  cat("Error: 'especime.csv' file not found!\n")
}

cat("**Legalities**")
if (file.exists("./data_raw/enquadramento.csv")) {
  enquad <- read_delim("./data_raw/enquadramento.csv", delim = ";")
} else {
  cat("Error: 'enquadramento.csv' file not found!\n")
}

cat("This is the amount of rows of broken laws that we have in the 'enquad' file:\n")
enquad_rows <- nrow(enquad)
print(enquad_rows)

# Number of rows in the `espec` file (species)
cat("This is how many rows of species that we have in the 'espec' file:\n")
espec_rows <- nrow(espec)
print(espec_rows)


# Combining datasets -----------------------------------------------------------

# All that have 'SEQ_AUTO_INFRACAO' in common
dados<-inner_join(espec,enquad, by=c("SEQ_AUTO_INFRACAO","ULTIMA_ATUALIZACAO_RELATORIO"))

# Number of rows in the combined `dados` dataset
cat("After combining the data of matching laws broken and species, we have 'dados' that has the amount of rows:\n")
dados_rows <- nrow(dados)
print(dados_rows)

# Data optimization ------------------------------------------------------------

cat("**Data optimizations**")
# 1.Simplify column names: e.g., NOME_CIENTIFICO
# 2.Translated from Portuguese to English 
# 3.Removed whitespace and filled blank with NA

cat("Translated to english and simplified titles through tidyverse")

dados <- dados %>%
  rename(
    infraction = SEQ_AUTO_INFRACAO,
    quantity = QUANTIDADE,
    unit = UNIDADE,
    type = TIPO,
    group = GRUPO,
    common_name = NOME_POPULAR,
    scientific_name = NOME_CIENTIFICO,
    description = DESCRICAO,
    life_state = CARACTERISTICA,
    situation = SITUACAO,
    last_report = ULTIMA_ATUALIZACAO_RELATORIO,
    article = ARTIGO,
    paragraph = PARAGRAFO,
    standard_type = TIPO_NORMA,
    standard_num = NUMERO_NORMA,
    standard_detail = DETALHE_NORMA,
    common_article = COM_ARTIGO,
    common_paragraph = COM_PARAGRAFO
  ) %>%
  mutate(
    across(where(is.character), ~ tolower(trimws(.))),
    across(where(is.character), ~ na_if(., ""))  
  )

# New columns (genus, species, subspecies)--------------------------------------

cat("Making new columns,scientific name will now become genus, species, subspecies")

dados <- separate(dados, scientific_name, 
                  into = c("genus", "species", "subspecies"), 
                  sep = "\\s+", fill = "right")

cat("Implementing codes for scientific name for readability and search")
cat("Using the first two char for genus and species: e.g Dasyprocta azarae -> daaz")

dados <- dados %>% 
  mutate(sp_code = paste0(substr(genus, 1, 2), 
                          substr(species, 1, 2), 
                          if_else(!is.na(subspecies), substr(subspecies, 1, 2), ""))) %>%
  relocate(sp_code, .before = "genus") %>%
  mutate(sp_code = case_when(sp_code == "NANA" ~ NA, 
                             .default = as.character(sp_code)))

# Issues encountered -----------------------------------------------------------

cat("Organized data frame, now finding specific areas that need a fix from the given CSV file\n")

# Count how many scientific names are missing a genus
cat("First, how many scientific names in our large data frame are missing a genus?\n")
missing_genus <- dados %>%
  filter(is.na(genus)) %>%
  count()
print(missing_genus)

# Count how many scientific names are missing a species
cat("How many are missing a species?\n")
missing_species <- dados %>%
  filter(is.na(species)) %>%
  count()
print(missing_species)

# Count how many are missing both genus and species
cat("How many are missing both?\n")
missing_both <- dados %>%
  filter(is.na(genus) & is.na(species)) %>%
  count()
print(missing_both)

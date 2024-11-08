# IBAMA Wildlife Trafficking Data Cleaning and Analytics
* NOT ALL CODE WILL BE PRESENTED DUE TO PRIVACY
This project is focused on processing, cleaning, and analyzing data related to wildlife trafficking provided by the **Brazilian Institute of Environment and Renewable Natural Resources (IBAMA)**. The goal is to generate insights by combining species and legal infraction data, enabling further research on wildlife trafficking patterns and conservation efforts.

## Project Overview

Wildlife trafficking is a critical environmental issue, and accurate data is essential for developing strategies to combat it. This project involved:
- Cleaning and processing over 800,000 legal records and 33,000 species records.
- Merging and analyzing datasets to create a combined, optimized dataset of 70,000 records.
- Translating data attributes from Portuguese to English and standardizing classifications for better usability in research and analytics.

## Datasets

The following datasets were used in this project:
- **Species Data (`especime.csv`)**: Contains records on species affected by wildlife trafficking, including scientific names, common names, and quantities.
- **Legal Infraction Data (`enquadramento.csv`)**: Contains information on legal infractions related to wildlife trafficking, including details of the laws violated.

## Data Cleaning and Analytics

Key steps in the data cleaning and analytics process include:
1. **Data Loading**: Import the species and legal infraction datasets using `read_delim`.
2. **Data Merging**: Combine the species and legal infraction datasets using a common identifier (`SEQ_AUTO_INFRACAO`).
3. **Data Translation and Optimization**:
   - Translate column names from Portuguese to English for better clarity.
   - Simplify dataset by cleaning and restructuring scientific names (genus, species, subspecies).
   - Generate species codes for easier readability and searchability.
4. **Data Analytics**:
   - Perform data quality checks to identify missing or inconsistent values.
   - Apply filtering and counting functions to analyze missing genus and species names.
   - Optimize the dataset for future research and analytics.

## Code Overview

The script is written in R, utilizing the following libraries:
- **tidyverse**: For data manipulation and cleaning.
- **janitor**: To streamline data cleaning tasks such as removing whitespace and handling missing values.

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ibama-data-cleaning.git
   cd ibama-data-cleaning

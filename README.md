# Veterans-Analysis

An analysis on U.S. veterans based on location, SCD compensation, and age for every county in the country.

## Disclaimers

- Based from the original dataset about veterans from data.gov, (source down below), I've decided to get rid of the columns of male and female, and added a column of veteran population by county veteran population (VA Census ACS 5-Year Estimates, 2022).
- MOST IMPORTANTLY: these results down below are solely based from this dataset, which I revised.

## Approach

- Python (pandas): cleaned and rearranged the data
- SQL: exploring and summarizing the data for each question
- R (ggplot2 included): running statistical tests for each question and creating charts based on each question (charts can be found on my Hersh Oza LinkedIn page)

## Question 1: In which states are veterans more or less likely to receive compensation than expected?

### Tests

**paired Wilcoxon signed-rank test:**
- Median % under 65: 54.3%
- Median % 65 and older: 45.7%
- Wilcoxon V = 3,267,471, p < 2.2e-16

### Interpretation



## Question 2: How are recipients spread across disability ratings, and do most counties have a majority rated 70%+?

### Tests

**pearson correlation test:**
- 
- simple linear regression test: 

### Interpretation



## Question 3: Are veterans under 65 more likely to receive compensation than veterans 65 and older?

### Tests

- chi-square goodness-of-fit test:
- one-sample Wilcoxon signed-rank test: 

### Interpretation


## Data Source

(Department of Veterans Affairs) https://catalog.data.gov/dataset/fy-2025-disability-compensation-recipients-by-county

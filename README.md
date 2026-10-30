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

### pearson correlation test:
- 
- simple linear regression test: 

### Interpretation

- 

## Question 3: How are service-connected disability (SCD) ratings distributed?

### chi-square goodness-of-fit test:

- X² = 1,042,268, df = 4, **p < 2.2e-16**
- Shares: 0–20%: **19.4%**, 30–40%: **10.5%**, 50–60%: **11.5%**, 70–90%: **29.5%**, 100%: **29.1%**

### Interpretation

- SCD ratings are not evenly distributed. The biggest observation is that around 59% of all recipients are rated 70% or higher, and more than a quarter is rated 100%. The middle groups (30–60%) are the smallest. According to Census Bureau data and VA reports, the cluster of high SCD ratings have been driven heavily by veterans in the Afghanistan and Iraq Wars. Ratings of 70% or higher surged from around 27% in 2008 to around 50% in 2022.

## Data Source

(Department of Veterans Affairs) https://catalog.data.gov/dataset/fy-2025-disability-compensation-recipients-by-county

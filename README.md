# Veterans Analysis

An analysis on U.S. veterans based on location, SCD compensation, and age for every county in the country.

## Disclaimers

- Based from the original dataset about veterans from data.gov, (source down below), I've decided to get rid of the columns of male and female, and added a column of veteran population by county veteran population (VA Census ACS 5-Year Estimates, 2022).
- MOST IMPORTANTLY: these results down below are solely based from this dataset, which I revised.

## Approach

- Python (pandas): cleaned and rearranged the data
- SQL: exploring and summarizing the data for each question
- R (ggplot2 included): running statistical tests for each question and creating charts based on each question (charts can be found on my Hersh Oza LinkedIn page)

## Are disability compensation recipients mostly younger or older veterans?

### paired Wilcoxon signed-rank test:

- Median % under 65: **54.3%**
- Median % 65 and older: **45.7%**
- Wilcoxon V = 3,267,471, **p < 2.2e-16**

### Interpretation

- For a typical county, slightly more than half of disability compensation recipients are under 65. The difference between the two groups is somewhat significant, although older veterans still make up close to half of recipients. According to Census Bureau data and VA reports, SCD compensation is mostly due to younger veterans serving in the more recent Afghanistan and Iraq wars, as opposed to older wars like Vietnam. 
  
## Do states with more veterans have more disability compensation recipients?

### pearson correlation test:

- **r = 0.973** (95% CI: 0.953 to 0.985), **p < 2.2e-16**

### Interpretation

- Regarding veteran population and recipient counts, the result above indicates a very strong, positive relationship. Much of this relationship reflects state size, since bigger states have more of both. The states of **Texas, North Carolina, Georgia, Oklahoma, and Alabama** have many more recipients. However, the states of **Pennsylvania, New York, Ohio, Illinois, and Michigan** have fewer than expected. Several of the states above the line are in the South and have large military installations, especially with forts. A recent article by The State found that South Carolina, albeit a smaller state, was the best state for military retirees. Like a lot of southern states, South Carolina possesses a business-friendly climate, especially for military and veteran, and doesn't tax military pensions. 

## How are service-connected disability (SCD) ratings distributed?

### chi-square goodness-of-fit test:

- X² = 1,042,268, df = 4, **p < 2.2e-16**
- Shares: 0–20%: **19.4%**, 30–40%: **10.5%**, 50–60%: **11.5%**, 70–90%: **29.5%**, 100%: **29.1%**

### Interpretation

- SCD ratings are not evenly distributed. The biggest observation is that around 59% of all recipients are rated 70% or higher, and more than a quarter is rated 100%. The middle groups (30–60%) are the smallest. As with the case with whether or not older or more younger veterans receive a significant amount of SCD compensation, the cluster of high SCD ratings have been driven heavily by veterans in the Afghanistan and Iraq Wars. In fact, census.gov found that ratings of 70% or higher surged from around 27% in 2008 to around 50% in 2022.

## Data Source

(Department of Veterans Affairs) https://catalog.data.gov/dataset/fy-2025-disability-compensation-recipients-by-county

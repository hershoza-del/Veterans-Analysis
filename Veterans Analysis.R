> library(dplyr)
> library(ggplot2)
> library(scales)
> options(scipen = 999)
> df <- read.csv("/Users/hershoza/Downloads/Veterans_Analysis_R.csv", check.names = FALSE, colClasses = c("FIPS code" = "character"))
> df <- df %>% select(-c(vlookup, xlookup, `index/match`, sumif, countif, `if`))

> counties <- df %>% filter(!`States/Territories` %in% c("Puerto Rico", + "Other Foreign Countries", "US Territories (excluding Puerto Rico)", "Unknown"))
 
> # ---- Age (boxplot) ----

> q1 <- counties %>%
  +     filter(`County Veteran Population` >= 100) %>%
  +     mutate(pct_under65 = (`Ages 17-44` + `Ages 45-64`) /
                 +                `Disability Compensation Recipients by County` * 100,
                 +            pct_65plus  = `Ages 65+` / `Disability Compensation Recipients by County` * 100) %>%
  +     filter(!is.na(pct_under65), !is.na(pct_65plus))
 
  > wilcox.test(q1$pct_under65, q1$pct_65plus, paired = TRUE)
  
  Wilcoxon signed rank test with
  continuity correction
  
  data:  q1$pct_under65 and q1$pct_65plus
  V = 3267471, p-value <
    0.00000000000000022
  alternative hypothesis: true location shift is not equal to 0
  
  > median(q1$pct_under65)
  [1] 54.29129
  > median(q1$pct_65plus)
  [1] 45.70871
 
  > boxplot(q1$pct_under65, q1$pct_65plus, names = c("Under 65", "65 and older"),
            +         ylab = "% of county recipients")

> # ---- States (scatterplot) ----
  
> states <- counties %>% group_by(`States/Territories`) %>%
  +     summarise(veterans   = sum(`County Veteran Population`, na.rm = TRUE),
                    +             recipients = sum(`Disability Compensation Recipients by County`, na.rm = TRUE)) %>%
  +     mutate(rate = recipients / veterans * 100)
 
  > cor.test(states$veterans, states$recipients)
  
  Pearson's product-moment
	      correlation

data:  states$veterans and states$recipients
t = 29.595, df = 49, p-value <
0.00000000000000022
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.9531987 0.9846624
sample estimates:
      cor 
0.9731496 

> model <- lm(recipients ~ veterans, data = states)
> summary(model)

Call:
lm(formula = recipients ~ veterans, data = states)

Residuals:
   Min     1Q Median     3Q    Max 
-85334  -9832   5734  10541 120261 

Coefficients:
               Estimate  Std. Error
(Intercept) -9405.74449  6249.77563
veterans        0.40609     0.01372
            t value
(Intercept)  -1.505
veterans     29.595
                       Pr(>|t|)    
(Intercept)               0.139    
veterans    <0.0000000000000002 ***
---
Signif. codes:  
  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05
  ‘.’ 0.1 ‘ ’ 1

Residual standard error: 31280 on 49 degrees of freedom
Multiple R-squared:  0.947,	Adjusted R-squared:  0.9459 
F-statistic: 875.9 on 1 and 49 DF,  p-value: < 0.00000000000000022

> states$residual <- resid(model)
> states %>% arrange(desc(residual)) %>% print(n = Inf)   # most above the line at the top
# A tibble: 51 × 5
   `States/Territories` veterans
   <chr>                   <int>
 1 Texas                 1408009
 2 North Carolina         618846
 3 Georgia                608876
 4 Oklahoma               247634
 5 Alabama                310187
 6 Virginia               637971
 7 South Carolina         344530
 8 Nebraska               105516
 9 Tennessee              406307
10 Hawaii                  89042
11 Mississippi            153838
12 Alaska                  58910
13 South Dakota            54527
14 Wyoming                 40952
15 Louisiana              217225
16 District Of Columbia    20481
17 North Dakota            43237
18 Idaho                  117609
19 West Virginia          109457
20 Colorado               348913
21 Utah                   113093
22 Minnesota              267133
23 Nevada                 201790
24 Montana                 81663
25 Rhode Island            47214
26 Arkansas               176468
27 Vermont                 34076
28 Maine                   97871
29 Delaware                61582
30 New Mexico             133239
31 Kansas                 154967
32 Florida               1347330
33 New Hampshire           89294
34 Kentucky               235118
35 Maryland               332655
36 Iowa                   166552
37 Oregon                 252530
38 Missouri               354505
39 Connecticut            140081
40 Indiana                338153
41 Wisconsin              296513
42 Washington             486714
43 Massachusetts          253731
44 Arizona                459818
45 New Jersey             285835
46 California            1355918
47 Michigan               479115
48 Illinois               493667
49 Ohio                   626617
50 New York               607728
51 Pennsylvania           656112
# ℹ 3 more variables:
#   recipients <int>, rate <dbl>,
#   residual <dbl>
 
> ggplot(states, aes(veterans, recipients)) +
+     geom_point() + geom_smooth(method = "lm", se = FALSE) +
+     scale_x_continuous(labels = label_comma()) +
+     scale_y_continuous(labels = label_comma()) +
+     labs(x = "Veteran population", y = "Disability compensation recipients")
`geom_smooth()` using formula = 'y ~ x'

> # ---- Ratings (bar chart) ----

> rating_cols <- c("0-20% SCD rating", "30-40% SCD rating", "50-60% SCD rating",
+                  "70-90% SCD rating", "100% SCD rating")
> totals <- colSums(counties[rating_cols], na.rm = TRUE)
> chisq.test(totals)                     # vs. an even split

	Chi-squared test for given
	probabilities

data:  totals
X-squared = 1042268, df = 4,
p-value < 0.00000000000000022

> round(totals / sum(totals) * 100, 1)   # percentages to report
 0-20% SCD rating 30-40% SCD rating 
             19.4              10.5 
50-60% SCD rating 70-90% SCD rating 
             11.5              29.5 
  100% SCD rating 
             29.1 
 
> bp <- barplot(totals, names.arg = c("0-20%", "30-40%", "50-60%", "70-90%", "100%"),
+               xlab = "SCD rating", ylab = "", yaxt = "n",
+               ylim = c(0, max(totals) * 1.1))
> axis(2, at = pretty(c(0, totals)), labels = label_comma()(pretty(c(0, totals))), las = 1)
> mtext("Recipients", side = 2, line = 4)

> complete <- counties[complete.cases(counties[c(rating_cols,
+                                                "Disability Compensation Recipients by County")]), ]
> share_high <- (complete$`70-90% SCD rating` + complete$`100% SCD rating`) /
+     complete$`Disability Compensation Recipients by County`
> wilcox.test(share_high, mu = 0.5, alternative = "greater")

	Wilcoxon signed rank test with
	continuity correction

data:  share_high
V = 3029056, p-value <
0.00000000000000022
alternative hypothesis: true location is greater than 0.5

> median(share_high)
[1] 0.5549591
> mean(share_high > 0.5)   # share of counties above half
[1] 0.724446

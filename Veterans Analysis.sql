# previewing the csv

SELECT * FROM data.veterans_analysis_sql;

# Are disability compensation recipients mostly younger or older veterans?

SELECT
    SUM(`Ages 17-44`) + SUM(`Ages 45-64`)                  AS recipients_under_65,
    SUM(`Ages 65+`)                                        AS recipients_65_plus,
    ROUND( (SUM(`Ages 17-44`) + SUM(`Ages 45-64`)) * 100.0
         / (SUM(`Ages 17-44`) + SUM(`Ages 45-64`) + SUM(`Ages 65+`)), 1)
                                                           AS pct_under_65
FROM data.veterans_analysis_sql
WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                   'US Territories (excluding Puerto Rico)', 'Unknown');

SELECT
    CASE
        WHEN `Ages 17-44` + `Ages 45-64` > `Ages 65+` THEN 'Mostly under 65'
        WHEN `Ages 17-44` + `Ages 45-64` < `Ages 65+` THEN 'Mostly 65 and older'
        ELSE 'Tied'
    END       AS county_group,
    COUNT(*)  AS number_of_counties
FROM data.veterans_analysis_sql
WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                   'US Territories (excluding Puerto Rico)', 'Unknown')
  AND `County Veteran Population` >= 100
  AND `Ages 17-44` IS NOT NULL
  AND `Ages 45-64` IS NOT NULL
  AND `Ages 65+`   IS NOT NULL
GROUP BY county_group;

# Do states with more veterans have more disability compensation recipients?

SELECT
    `States/Territories`                                         AS State,
    SUM(`County Veteran Population`)                             AS veterans,
    SUM(`Disability Compensation Recipients by County`)          AS recipients,
    ROUND(SUM(`Disability Compensation Recipients by County`) * 100.0
          / SUM(`County Veteran Population`), 1)                 AS per_100_veterans
FROM data.veterans_analysis_sql
WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                   'US Territories (excluding Puerto Rico)', 'Unknown')
  AND `County Veteran Population` IS NOT NULL
  AND `Disability Compensation Recipients by County` IS NOT NULL
GROUP BY `States/Territories`
ORDER BY per_100_veterans DESC;

SELECT
    State,
    per_100_veterans,
    CASE
        WHEN per_100_veterans >= 43 THEN 'Above expected'
        WHEN per_100_veterans <= 33 THEN 'Below expected'
        ELSE 'About as expected'
    END AS compared_to_nation         
FROM (
    SELECT
        `States/Territories` AS State,
        ROUND(SUM(`Disability Compensation Recipients by County`) * 100.0
              / SUM(`County Veteran Population`), 1) AS per_100_veterans
    FROM data.veterans_analysis_sql
    WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                       'US Territories (excluding Puerto Rico)', 'Unknown')
      AND `County Veteran Population` IS NOT NULL
      AND `Disability Compensation Recipients by County` IS NOT NULL
    GROUP BY `States/Territories`
) AS state_rates
ORDER BY per_100_veterans DESC;

# How are service-connected disability (SCD) ratings distributed?

SELECT
    SUM(`0-20% SCD rating`)   AS rated_0_20,
    SUM(`30-40% SCD rating`)  AS rated_30_40,
    SUM(`50-60% SCD rating`)  AS rated_50_60,
    SUM(`70-90% SCD rating`)  AS rated_70_90,
    SUM(`100% SCD rating`)    AS rated_100,
    ROUND( (SUM(`70-90% SCD rating`) + SUM(`100% SCD rating`)) * 100.0
         / SUM(`Disability Compensation Recipients by County`), 1) AS pct_rated_70_plus
FROM data.veterans_analysis_sql
WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                   'US Territories (excluding Puerto Rico)', 'Unknown');

SELECT
    CASE
        WHEN (`70-90% SCD rating` + `100% SCD rating`) * 1.0
             / `Disability Compensation Recipients by County` > 0.5
        THEN 'Majority rated 70%+'
        ELSE 'Not a majority'
    END       AS county_group,
    COUNT(*)  AS number_of_counties
FROM data.veterans_analysis_sql
WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                   'US Territories (excluding Puerto Rico)', 'Unknown')
  AND `0-20% SCD rating`  IS NOT NULL
  AND `30-40% SCD rating` IS NOT NULL
  AND `50-60% SCD rating` IS NOT NULL
  AND `70-90% SCD rating` IS NOT NULL
  AND `100% SCD rating`   IS NOT NULL
GROUP BY county_group;

# separate join function

WITH state_rates AS (
    SELECT
        `States/Territories` AS State,
        ROUND(SUM(`Disability Compensation Recipients by County`) * 100.0
              / SUM(`County Veteran Population`), 1) AS state_per_100
    FROM data.veterans_analysis_sql
    WHERE `States/Territories` NOT IN ('Puerto Rico', 'Other Foreign Countries',
                                       'US Territories (excluding Puerto Rico)', 'Unknown')
      AND `County Veteran Population` IS NOT NULL
      AND `Disability Compensation Recipients by County` IS NOT NULL
    GROUP BY `States/Territories`
)
SELECT
    v.`States/Territories`                                       AS State,
    v.County,
    v.`Recipients per 100 Veterans`                              AS county_per_100,
    s.state_per_100,
    ROUND(v.`Recipients per 100 Veterans` - s.state_per_100, 1)  AS difference
FROM data.veterans_analysis_sql AS v
INNER JOIN state_rates AS s
        ON v.`States/Territories` = s.State
WHERE v.`County Veteran Population` >= 100
ORDER BY difference DESC
LIMIT 20;

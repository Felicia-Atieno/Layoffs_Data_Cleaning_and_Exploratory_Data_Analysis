# Layoffs Data Cleaning and Exploratory Data Analysis

## Overview
This project showcases the cleaning, preparation, and exploratory data analysis of a global layoffs dataset, containing information on company name, location, industry, number of layoffs, date, stage, country, and funds raised. 

## Data Sources
The dataset used in this project is the "layoffs.csv" file, containing detailed information on global layoffs. The dataset contains information for the period March 2020 to March 2023.

## Tools
MySQL

## Data Cleaning and Preparation
In this initial phase, I performed the following tasks;
1. Data loading and inspection.
2. Deleting duplicate.
3. Standardizing the data.
4. Handling nulls and blank values.
5. Removing columns and rows that were not useful.
#### Example query for data cleaning (standardizing)
```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```


## Exploratory Data Analysis
SQL queries were used to analyze and visualize trends in the data. Some key questions explored were;
1. Which country had the highest total number of layoffs?
2. Which year had the highest number of layoffs?
3. How have layoffs trended over the period?
4. Which companies laid off the highest number of employees per year?
#### Example Query for EDA (Layoffs rolling total by month)
```sql
SELECT SUBSTRING(`date`, 1, 7) `Month`, SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH t1 AS(
SELECT SUBSTRING(`date`, 1, 7) `Month`, SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC)
SELECT `Month`,total_off, SUM(total_off)OVER(ORDER BY `Month`) AS rolling_total  
FROM t1;
```

## Results/Findings
1. The United States had the highest total number of layoffs over the period.
2. Most of the layoffs occurred in the year 2022.
3. There was a sharp increase in layoffs over the year 2022 compared to a much lower increase in 2021.
4. For each year, these companies had the highest number of layoffs;
   
   2020 - Uber
   
   2021 - ByteDance
   
   2022 - Meta
   
   2023 - Google.

##EDA

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

##RANKING THE TOTAL LAID OFF BY COUNTRY, INDUSTRY, OR COMPANY,STAGE, DATE
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

##DATE RANGE?
SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;
## MARCH 2020 to MARCH 2023

## checking 100%  layoffs
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

##checking total layoffs by year
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;

###PROGRESSION OF LAYOFFS (ROLLING TOTAL)
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

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

##Ranking which companies laid off the most employees per year
WITH Company_year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <=5;
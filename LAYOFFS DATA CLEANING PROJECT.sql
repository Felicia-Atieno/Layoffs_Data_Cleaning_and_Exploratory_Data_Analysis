SELECT * 
FROM world_layoffs.layoffs;

#DATA CLEANING
  ##DELETING DUPLICATES (Removing duplicates for this is harder since we do not have a unique identifier for the data)
  
   ###CREATING A TABLE TO WORK ON
   CREATE TABLE layoffs_staging
   LIKE  world_layoffs.layoffs;
   
   ##INSERTING DATA
   SELECT * 
FROM world_layoffs.layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging;

WITH CTE AS (
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging
)
SELECT *
FROM CTE
WHERE row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;

DELETE 
FROM layoffs_staging2
WHERE row_num>1;

SELECT * 
FROM layoffs_staging2;


##STANDARDIZING DATA (Finding Issues in Your Data then Fixing it)

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT company
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.'FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country =  TRIM(TRAILING '.'FROM country)
WHERE country LIKE 'United States%';

SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT date
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

##NULLS AND BLANK VALUES
SELECT * 
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT *
from layoffs_staging2
WHERE industry IS NULL OR industry = '';

SELECT *
from layoffs_staging2
WHEre company ='Airbnb';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging t2
    ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

##REMOVING COLUMNS AND ROWS NOT USEFUL

SELECT * 
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE  
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM world_layoffs.layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
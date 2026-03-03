-- DATA CLEANING

-- 1. REMOVE DUPLICATES (REMOVER VALORES DUPLICADOS)
-- 2. STANDARDIZE THE DATA (PADRONIZAR OS DADOS) 
-- 3. NULL VALUES OR BLANK VALUES
-- 4. REMOVE ANY COLUMNS

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs ;

-- 1. REMOVE DUPLICATES
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

with duplicated_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicated_cte
WHERE row_num > 1;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * from layoffs_staging2
where row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- 2. Standardize data

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company, TRIM(company) FROM layoffs_staging2;


SELECT DISTINCT industry FROM layoffs_staging2
ORDER BY industry;

SELECT * FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location FROM layoffs_staging2
ORDER BY location;

SELECT DISTINCT country FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT country FROM layoffs_staging2
ORDER BY country;

SELECT `date`, str_to_date(`date`,'%m/%d/%Y') FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`,'%m/%d/%Y');

SELECT `date` FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. NULL VALUES OR BLANK VALUES

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- 4. REMOVE ANY COLUMNS OR ROWs

DELETE  FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE
layoffs_staging2
DROP COLUMN row_num;


SELECT * FROM layoffs_staging2;

-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

select company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


select company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

select industry, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

select YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;


SELECT substring(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY substring(`date`, 1, 7)
ORDER BY 1;

WITH rolling_total AS
(
SELECT substring(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY substring(`date`, 1, 7)
ORDER BY 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM rolling_total;


select company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_year (company, years, total_laid_off) AS (

select company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_year_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_year
WHERE years IS NOT NULL
ORDER BY ranking
)
SELECT * FROM Company_year_rank
WHERE ranking <=5;
;
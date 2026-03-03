# 📊 World Layoffs Analysis: Data Cleaning & Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project involves a comprehensive data pipeline using **MySQL** to process a raw dataset of global layoffs. The goal was to transform unorganized, "dirty" data into a clean, structured format ready for professional analysis and business intelligence.

## 🛠️ Technical Implementation

### 1. Data Cleaning & Transformation
Focusing on data integrity and reliability:
* **Duplicate Removal:** Utilized `ROW_NUMBER()` and `CTE` (Common Table Expressions) to identify and delete redundant records.
* **Standardization:** Normalized inconsistent strings in `industry` and `country` columns using `TRIM` and `LIKE` patterns.
* **Date Conversion:** Transformed text-based date strings into proper `DATE` formats using `STR_TO_DATE` for time-series compatibility.
* **Null Value Management:** Applied `SELF-JOINS` to populate missing industry data based on existing company records.

### 2. Exploratory Data Analysis (EDA)
Extracting meaningful trends from the cleaned dataset:
* **Ranking:** Implemented `DENSE_RANK` within `CTEs` to identify the top 5 companies with the highest layoffs per year.
* **Time-Series Insights:** Calculated **Monthly Rolling Totals** of layoffs to visualize market contraction trends over time.
* **Aggregations:** Summarized total job losses by industry, company stage, and location.

## 📂 Repository Structure
* `data_cleaning.sql`: Full script for the data staging and cleaning process.
* `data_analysis.sql`: Collection of complex queries for exploratory analysis and business insights.


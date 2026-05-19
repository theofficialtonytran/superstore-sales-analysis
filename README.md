# Superstore Sales Performance Analysis | 2014–2017

## Overview
End-to-end data analysis project using SQL, Python, and Tableau to analyze 
4 years of retail sales data for a fictional office supply company. 
The analysis identifies key drivers of margin erosion and provides 
actionable business recommendations.

**Tools:** DuckDB · DBeaver · Python (pandas, matplotlib, seaborn) · Tableau Public

---

## Dashboard
🔗 [View Live Tableau Dashboard](https://public.tableau.com/app/profile/tony.tran8567/viz/SuperstoreSalesPerformance_17791501716000/SuperstoreSalesPerformance2014-2017)

![Dashboard Screenshot](images/Superstore_Sales_Performance%20_2014-2017.png)

---

## Key Findings

**1. Revenue grew 51% over 4 years — but margin is under pressure**
- Total sales grew from $484K in 2014 to $733K in 2017
- Overall profit margin peaked at 13.43% in 2016 then declined to 
  12.74% in 2017 despite record revenue
- This divergence signals a structural profitability problem

**2. Furniture is destroying margin**
- Tables generate $207K in revenue but produce a net loss of $17,725 
  (-8.56% margin)
- Bookcases lose an additional $3,472 annually
- Root cause: Tables carry a 26% average discount rate — 
  the third highest in the entire product catalog

**3. The discount-to-loss pipeline is clear**
- Sub-categories with discounts above 20% are overwhelmingly unprofitable
- Sub-categories with discounts below 8% (Labels, Paper, Envelopes) 
  are the most profitable in the business
- Eliminating deep discounts on Tables alone would recover ~$17K 
  in annual profit

**4. The West region leads, Central lags significantly**
- West: $725K sales, 14.94% margin
- Central: $501K sales, 7.92% margin — less than half the West's rate
- Geographic margin gap points to regional pricing or discount policy differences

**5. Smaller segments are more efficient**
- Home Office: smallest segment by revenue, highest margin at 14.03%
- Consumer: largest segment by revenue, lowest margin at 11.55%

---

## Business Recommendation
Superstore should audit its discount policy for Furniture — 
particularly Tables. The data shows no margin benefit from discounts 
above 20%. Capping Table discounts at 10% and reallocating 
promotional spend to high-margin Office Supplies categories 
(Paper, Labels, Envelopes) would materially improve overall profitability.

---

## Repository Structure
**superstore-sales-analysis/**
- README.md
- sql/
    - analysis_queries.sql        (7 business-driven SQL queries)
- python/
    - superstore_analysis.ipynb   (Discount vs profit visualization)
- data/
    - superstore_cleaned.csv      (Source dataset)
- images/
    - dashboard_screenshot.png     (Tableau dashboard)
    - discount_vs_profit.png       (Python scatter plot)

---

## SQL Analysis Highlights
All queries written in DuckDB via DBeaver. Key queries include:
- Top-line KPI aggregation (sales, profit, margin %)
- Monthly trend analysis with seasonal pattern identification
- Regional performance comparison
- Sub-category margin ranking (identified Tables at -8.56% margin)
- Discount vs profit correlation by sub-category

---

## Visualizations

### Discount vs Profit (Python)
![Discount vs Profit](images/discount_vs_profit.png)

---
*Dataset: Sample Superstore (public dataset via Kaggle)*
https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
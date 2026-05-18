-- Initial EDA

SELECT * FROM superstore;

-- How big is it?
SELECT COUNT(*) FROM superstore;

-- What does a row look like?
SELECT * FROM superstore LIMIT 10;

-- What date range are you working with?
SELECT MIN(order_date), MAX(order_date) FROM superstore;

-- Any nulls in key columns?
SELECT 
  COUNT(*) - COUNT(sales) AS missing_sales,
  COUNT(*) - COUNT(profit) AS missing_profit,
  COUNT(*) - COUNT(customer_id) AS missing_customer_id
FROM superstore;

-- Looking into trends

-- 1. Top-line KPIs. 
SELECT
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore;

--Feedback:  healthy enough to be a functioning business, thin enough that the discount/category breakdown will reveal problems.

-- 2. Monthly sales & profit trend
SELECT
  DATE_TRUNC('month', order_date) AS month,
  ROUND(SUM(sales), 2) AS monthly_sales,
  ROUND(SUM(profit), 2) AS monthly_profit
FROM superstore
GROUP BY 1
ORDER BY 1;

--Feedback: Clear YoY sales growth — January 2014 was $14k, January 2017 was $44k. The business roughly tripled over 4 years.
-- September, November, December are consistently the biggest months every year — classic retail seasonality, great for a Tableau annotation.

-- July 2014: $33.9k sales, -$841 profit
-- January 2015: $18.2k sales, -$3,281 profit
-- These are your "problem months" — almost certainly heavy discounting. Query 4 will tell us which categories are responsible.

-- 3. Sales & profit by region
SELECT
  region,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- West leads in both sales and margin (14.94%)
-- Central is the problem region — nearly $500k in sales but only 7.92% margin, less than half the West's rate
-- That gap between West and Central is a dashboard highlight worth calling out explicitly

-- 4. Profit margin by category
SELECT
  category,
  "sub-category",
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category, "sub-category"
ORDER BY profit_margin_pct ASC;

--Feedback: Most important query 
-- Furniture is destroying margin. Three sub-categories are actively losing money:

--Tables: -$17,725 loss on $207k in sales — the worst offender by far
--Bookcases: -$3,472 loss
--Supplies: -$1,189 loss

-- Meanwhile the business's best performers are Paper (43%), Labels (44%), and Copiers (37%) — all low-glamour, high-margin products nobody thinks about.

-- Follow up Queries

-- 5. Discount vs profit by sub-category (the smoking gun)
SELECT
  "sub-category",
  ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY "sub-category"
ORDER BY avg_discount_pct DESC;

--Binders are the most discounted product at 37% average discount — yet still profitable at 14.86%. 
--That's actually an interesting side note. But the real story is the discount-to-destruction pipeline in Furniture:

--Tables: 26% avg discount → -8.56% margin
--Bookcases: 21% avg discount → -3.02% margin

-- 6. YoY sales growth summary
SELECT
  YEAR(order_date) AS year,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY year
ORDER BY year;

--Revenue grew 51% from 2014 to 2017 — strong
-- Profit margin peaked in 2016 at 13.43% then dipped in 2017 to 12.74% despite record sales
-- That 2017 divergence — more sales, lower margin — is a red flag that something structural is wrong, and your sub-category analysis explains exactly what it is

-- Last Query

-- 7. Segment performance
SELECT
  segment,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
  COUNT(DISTINCT "order_id") AS total_orders
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- Home Office is your most efficient segment at 14.03% despite being smallest by revenue
--Consumer drives the most revenue and orders but has the worst margin at 11.55%
--Corporate sits in the middle on all three metrics
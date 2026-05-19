-- Initial EDA

SELECT * FROM superstore;

-- Size of dataset: 9,994 rows
SELECT COUNT(*) FROM superstore;

-- 10 random rows to get a sense of the data. Each row contains a row_id, order_id, order_date, ship_date, ship_mode, 
-- customer_id, segment, country, city, state, postal_code, region, product_id, category, sub-category, product_name, 
-- sales, quantity, discount, profit.
SELECT * FROM superstore LIMIT 10;

-- Dataset range: January 2014 to December 2017, which is a good length of time to analyze trends without being overwhelming.
SELECT MIN(order_date), MAX(order_date) FROM superstore;

-- Checking for nulls. Output yielded 0 NAs.
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

--Notes: Healthy enough to be a functioning business, thin enough that the discount/category breakdown will reveal problems.

-- 2. Monthly sales & profit trend
SELECT
  DATE_TRUNC('month', order_date) AS month,
  ROUND(SUM(sales), 2) AS monthly_sales,
  ROUND(SUM(profit), 2) AS monthly_profit
FROM superstore
GROUP BY 1
ORDER BY 1;

-- Notes: 
  -- Clear YoY sales growth: January 2014 had $14k in sales, while January 2017 was $44k. This means that the business roughly tripled over 4 years.
  -- September, November, December are consistently the biggest months every year
  -- Some months had negative profit:
    -- July 2014: $33.9k sales, -$841 profit
    -- January 2015: $18.2k sales, -$3,281 profit
  -- "Problem Months" - most likely due to overdiscounting. 

-- 3. Sales & profit by region
SELECT
  region,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Notes:
  -- West leads in both sales and margin (with a 14.94% profit margin)
  -- Central falls behind: nearly $500k in sales but only 7.92% margin, which is less than half the West's rate

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

-- Notes: Most important query 
  -- Furniture is destroying margin. Three sub-categories are actively losing money:
    --Tables: -$17,725 loss on $207k in sales (-8.56% margin)
    --Bookcases: -$3,472 loss (-3.02% margin)
    --Supplies: -$1,189 loss (-1.17% margin)
  -- Meanwhile, the business's best performers are Paper, Labels, and Copiers
    -- Paper: (43% margin) 
    -- Labels: (44% margin)
    -- Copiers: (37% margin)

-- Follow up Queries

-- 5. Discount vs profit by sub-category
SELECT
  "sub-category",
  ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY "sub-category"
ORDER BY avg_discount_pct DESC;

-- Notes: 
  -- Binders are the most discounted product at 37% average discount - yet still profitable at 14.86%. 
  -- Discount-to-destruction pipeline in Furniture:
    --Tables: 26% avg discount has a -8.56% margin
    --Bookcases: 21% avg discount has a -3.02% margin

-- 6. YoY sales growth summary
SELECT
  YEAR(order_date) AS year,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY year
ORDER BY year;

--Notes: 
  -- Revenue grew 51% from 2014 to 2017 
  -- Profit margin peaked in 2016 at 13.43% then dipped in 2017 to 12.74% despite record sales
  -- Divergence from 2016 to 2017 spotted. 
    -- More sales, lower margin 

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

-- Notes: 
  -- Home Office is your most efficient segment at 14.03% despite being smallest by revenue
  -- Consumer drives the most revenue and orders but has the worst margin at 11.55%
  -- Corporate sits in the middle on all three metrics
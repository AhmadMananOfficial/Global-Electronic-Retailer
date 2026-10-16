----------------------------------------------------------------------------------------------------
-- DESCRIPTION: Exploratory data analysis scripts tracking overall sales health, regional store 
--              efficiency, product category breakdowns, and inventory Pareto distribution.
----------------------------------------------------------------------------------------------------


-- Quick sanity check on the stores dimension table to verify row counts 
-- and unique geographic distribution before joining it with transactional data.
SELECT
    COUNT(*) AS t_rows,
    COUNT(DISTINCT StoreKey) AS Unique_Stores,
    COUNT(DISTINCT state) AS Unique_states
FROM Stores;


-- Evaluating market performance by country. This helps us see which regions 
-- generate the highest revenue and how efficiently they utilize store space (Revenue per Square Meter).
WITH stores_by_country AS (  
    SELECT 
        Country,
        COUNT(*) AS Total_Stores,
        SUM(Square_Meters) AS Total_Square_Meters 
    FROM Stores 
    GROUP BY Country
)  
SELECT 
    s.Country,  
    s.Total_Stores,
    s.Total_Square_Meters, 
    ROUND(SUM(Revenue), 0) AS Total_Revenue_USD, 
    ROUND(SUM(Gross_Profit), 0) AS Gross_Profit_USD, 
    ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS Gross_Margin_Pct, 
    ROUND(SUM(Revenue) / s.Total_Square_Meters, 0) AS Revenue_Per_SqMeter 
FROM stores_by_country s  
JOIN vw_sales_analysis r 
    ON s.Country = r.Store_Country 
GROUP BY s.Country, s.Total_Stores, s.Total_Square_Meters
ORDER BY Revenue_Per_SqMeter DESC;


-- Drilling down to the store/state level to spot our top-performing locations 
-- and check if store age has any visible impact on sales efficiency.
WITH stores_by_country AS (  
    SELECT 
        Country, 
        state, 
        MAX(open_date) AS open_date,
        SUM(Square_Meters) AS Total_Square_Meters
    FROM Stores 
    GROUP BY Country, state 
)  
SELECT  
    s.Country,
    s.State,
    MAX(s.open_date) AS Open_Date,
    s.Total_Square_Meters, 
    ROUND(SUM(Revenue), 0) AS Total_Revenue_USD, 
    ROUND(SUM(Gross_Profit), 0) AS Gross_Profit_USD, 
    ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS Gross_Margin_Pct, 
    ROUND(SUM(Revenue) / s.Total_Square_Meters, 0) AS Revenue_Per_SqMeter,
    MAX(r.Store_Age_Years) AS Store_Age_Years
FROM stores_by_country s  
JOIN vw_sales_analysis r 
    ON s.Country = r.Store_Country 
   AND s.state = r.Store_State
GROUP BY s.Country, s.state, s.Total_Square_Meters
ORDER BY Revenue_Per_SqMeter DESC;


-- Brand performance breakdown. Let's see which brands pull in the most cash 
-- and which ones give us the healthiest profit margins.
SELECT  
    brand,
    ROUND(SUM(quantity * unit_price_usd), 0) AS Total_Revenue_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)), 0) AS Gross_Profit_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)) / SUM(quantity * unit_price_usd) * 100, 2) AS Gross_Margin_Pct
FROM products p
JOIN sales s 
    ON s.productkey = p.productkey
GROUP BY brand
ORDER BY Total_Revenue_USD DESC;


-- Category-level breakdown to understand high-level product demand 
-- and figure out where the bulk of our retail revenue comes from.
SELECT  
    category,
    ROUND(SUM(quantity * unit_price_usd), 0) AS Total_Revenue_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)), 0) AS Gross_Profit_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)) / SUM(quantity * unit_price_usd) * 100, 2) AS Gross_Margin_Pct
FROM products p
JOIN sales s 
    ON s.productkey = p.productkey
GROUP BY category
ORDER BY Total_Revenue_USD DESC;


-- Subcategory analysis for a more granular look at product performance, 
-- including total units sold and product diversity within each group.
SELECT  
    category,
    subcategory,
    COUNT(DISTINCT p.productkey) AS Number_of_Products,
    SUM(s.quantity) AS Total_Quantity,
    ROUND(SUM(quantity * unit_price_usd), 0) AS Total_Revenue_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)), 0) AS Gross_Profit_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)) / SUM(quantity * unit_price_usd) * 100, 2) AS Gross_Margin_Pct
FROM products p
JOIN sales s 
    ON s.productkey = p.productkey
GROUP BY category, subcategory
ORDER BY Total_Revenue_USD DESC;


-- Granular product-level performance metrics combining quantities, 
-- revenue, and gross margins for every individual SKU.
SELECT
    p.productkey,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    SUM(s.quantity) AS Total_Quantity,
    ROUND(SUM(s.quantity * p.unit_price_usd), 0) AS Total_Revenue_USD,
    ROUND(SUM(s.quantity * (p.unit_price_usd - p.unit_cost_usd)), 0) AS Gross_Profit_USD,
    ROUND(SUM(s.quantity * (p.unit_price_usd - p.unit_cost_usd)) / SUM(s.quantity * p.unit_price_usd) * 100, 2) AS Gross_Margin_Pct
FROM products p
JOIN sales s 
    ON s.productkey = p.productkey
GROUP BY p.productkey, p.product_name, p.category, p.subcategory, p.brand
ORDER BY Total_Revenue_USD DESC;


-- Identifying our absolute top 10 best-selling products by total revenue 
-- to spotlight our core revenue drivers.
SELECT  
    product_name,
    SUM(quantity) AS qty, 
    ROUND(SUM(quantity * unit_price_usd), 0) AS Total_Revenue_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)), 0) AS Gross_Profit_USD, 
    ROUND(SUM(quantity * (unit_price_usd - unit_cost_usd)) / SUM(quantity * unit_price_usd) * 100, 2) AS Gross_Margin_Pct
FROM products p
JOIN sales s 
    ON s.productkey = p.productkey
GROUP BY product_name
ORDER BY Total_Revenue_USD DESC
LIMIT 10;


-- Pareto analysis by subcategory to test the 80/20 rule 
-- and see which subcategories drive the majority of our revenue.
WITH subcat_rev AS (
    SELECT
        p.Category,
        p.Subcategory,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Products p
    JOIN Sales s 
        ON s.ProductKey = p.ProductKey
    GROUP BY p.Category, p.Subcategory
),
running AS (
    SELECT
        Category,
        Subcategory,
        Revenue,
        SUM(Revenue) OVER (
            ORDER BY Revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Cumulative_Revenue,
        SUM(Revenue) OVER () AS Grand_Total,
        ROW_NUMBER() OVER (ORDER BY Revenue DESC) AS Rank_No,
        COUNT(*) OVER () AS Total_Items
    FROM subcat_rev
)
SELECT
    Rank_No,
    Category,
    Subcategory,
    ROUND(Revenue, 0) AS Revenue_USD,
    ROUND(Cumulative_Revenue, 0) AS Cumulative_Revenue_USD,
    ROUND(Cumulative_Revenue / Grand_Total * 100, 2) AS Cumulative_Pct
FROM running
ORDER BY Rank_No;


-- Product-level Pareto analysis (ABC Classification) to segment inventory items 
-- into A (top 80%), B (next 15%), and C (bottom 5%) revenue buckets.
WITH cat_rev AS (
    SELECT
        p.product_name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Products p
    JOIN Sales s 
        ON s.ProductKey = p.ProductKey
    GROUP BY p.product_name
),
running AS (
    SELECT
        product_name,
        Revenue,
        SUM(Revenue) OVER (
            ORDER BY Revenue DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Cumulative_Revenue,
        SUM(Revenue) OVER () AS Grand_Total,
        ROW_NUMBER() OVER (ORDER BY Revenue DESC) AS Rank_No,
        COUNT(*) OVER () AS Total_Items
    FROM cat_rev
)
SELECT
    Rank_No,
    product_name,
    ROUND(Revenue, 0) AS Revenue_USD,
    ROUND(Cumulative_Revenue, 0) AS Cumulative_Revenue_USD,
    ROUND(Cumulative_Revenue / Grand_Total * 100, 2) AS Cumulative_Pct,
    ROUND(Rank_No / Total_Items * 100, 2) AS Item_Pct,
    CASE
        WHEN Cumulative_Revenue / Grand_Total <= 0.80 THEN 'A'
        WHEN Cumulative_Revenue / Grand_Total <= 0.95 THEN 'B'
        ELSE 'C'
    END AS Pareto_Class
FROM running
ORDER BY Rank_No;


-- Checking customer demographics by grouping our total user base by gender.
SELECT 
    gender,
    COUNT(*) AS total_customers
FROM customers 
GROUP BY gender;
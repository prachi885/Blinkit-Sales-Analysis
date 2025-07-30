-- =============================================
-- Blinkit Sales Analysis - SQL Implementation
-- =============================================

-- 🔍 0. Table structure & cleaning

-- Check table and column names
SHOW TABLES;
DESCRIBE blinkit_grocery_data;

-- Rename wrongly encoded column
ALTER TABLE blinkit_grocery_data
CHANGE `ï»¿Item Fat Content` item_fat_content TEXT;

-- Standardize values in item_fat_content
SET SQL_SAFE_UPDATES = 0;
UPDATE blinkit_grocery_data
SET item_fat_content = 
  CASE
    WHEN item_fat_content IN ("LF", "low fat") THEN "Low Fat"
    WHEN item_fat_content = "reg" THEN "Regular"
    ELSE item_fat_content
  END;

-- ===================================================
-- ✅ 1. KPI Metrics: Total Sales, Average Sales, etc.
-- ===================================================

-- 🎯 Total Sales (in millions)
SELECT ROUND(SUM(Sales)/1000000, 2) AS Total_Sales_Millions
FROM blinkit_grocery_data;

-- 🎯 Average Sales (rounded to 0 decimals)
SELECT CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales
FROM blinkit_grocery_data;

-- 🎯 Number of Items
SELECT COUNT(*) AS No_of_Items
FROM blinkit_grocery_data;

-- 🎯 Average Rating
SELECT ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_grocery_data;

-- =========================================================
-- ✅ 2. Total Sales by Fat Content + All KPIs per Fat Type
-- =========================================================

SELECT 
  item_fat_content,
  CONCAT(ROUND(SUM(Sales)/1000, 2), 'K') AS Total_Sales_Thousands,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_grocery_data
GROUP BY item_fat_content
ORDER BY Total_Sales_Thousands DESC;

-- =========================================================
-- ✅ 3. Total Sales by Item Type + All KPIs per Item Type
-- =========================================================

SELECT 
  `Item Type`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_grocery_data
GROUP BY `Item Type`
ORDER BY Total_Sales DESC;

-- ===================================================================
-- ✅ 4. Fat Content by Outlet (Sales + KPIs by Location + Fat Content)
-- ===================================================================

-- a) Total Sales by Outlet Location & Fat Category
SELECT 
  `Outlet Location Type`,
  ROUND(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN Sales ELSE 0 END), 2) AS Low_Fat_Sales,
  ROUND(SUM(CASE WHEN item_fat_content = 'Regular' THEN Sales ELSE 0 END), 2) AS Regular_Sales
FROM blinkit_grocery_data
GROUP BY `Outlet Location Type`;

-- b) KPIs by Location & Fat Content
SELECT 
  `Outlet Location Type`,
  item_fat_content,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_grocery_data
GROUP BY `Outlet Location Type`, item_fat_content
ORDER BY `Outlet Location Type`, item_fat_content;

-- ====================================================
-- ✅ 5. Total Sales by Outlet Establishment Year (KPI)
-- ====================================================

SELECT 
  `Outlet Establishment Year`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating
FROM blinkit_grocery_data
GROUP BY `Outlet Establishment Year`
ORDER BY Total_Sales DESC;

-- =====================================================
-- ✅ 6. % of Total Sales by Outlet Size (Chart Friendly)
-- =====================================================

SELECT 
  `Outlet Size`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage
FROM blinkit_grocery_data
GROUP BY `Outlet Size`
ORDER BY Total_Sales DESC;

-- ================================================
-- ✅ 7. Sales Distribution by Outlet Location Type
-- ================================================

SELECT 
  `Outlet Location Type`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating,
  ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage
FROM blinkit_grocery_data
GROUP BY `Outlet Location Type`
ORDER BY Total_Sales DESC;

-- ====================================================
-- ✅ 8. All Metrics by Outlet Type (Total/Avg/Count)
-- ====================================================

SELECT 
  `Outlet Type`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(AVG(Sales), 2) AS Avg_Sales,
  COUNT(*) AS No_of_Items,
  ROUND(AVG(Rating), 2) AS Avg_Rating,
  ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage
FROM blinkit_grocery_data
GROUP BY `Outlet Type`
ORDER BY Total_Sales DESC;

**DISCLAIMER**
--Here queries are used in Google Bigquery instead of SQL Server Management Studio, so the queries are slightly different than the regular SQL server queries!

--Selecting the first 5 rows using the limit in BigQuery
SELECT * 
FROM `propane-choir-395311.Superstore_sales.raw_data` LIMIT 5;

--1. Total sales and total profits of each year
SELECT EXTRACT(Year From Order_Date) As year
FROM `propane-choir-395311.Superstore_sales.raw_data`;

ALTER TABLE `propane-choir-395311.Superstore_sales.raw_data`
ADD COLUMN year INT;

UPDATE `propane-choir-395311.Superstore_sales.raw_data`
SET year = EXTRACT(YEAR FROM Order_Date)
WHERE true;

SELECT year, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY year
ORDER BY year ASC;

--2. Total profits and total sales per quarter?

SELECT
  year,
  CASE
    WHEN EXTRACT(MONTH FROM Order_Date) IN (1, 2, 3) THEN 'Q1'
    WHEN EXTRACT(MONTH FROM Order_Date) IN (4, 5, 6) THEN 'Q2'
    WHEN EXTRACT(MONTH FROM Order_Date) IN (7, 8, 9) THEN 'Q3'
    ELSE 'Q4'
  END AS quarter
FROM
  `propane-choir-395311.Superstore_sales.raw_data`
ORDER BY
  year;

ALTER TABLE `propane-choir-395311.Superstore_sales.raw_data`
ADD COLUMN quarter STRING;

UPDATE `propane-choir-395311.Superstore_sales.raw_data`
SET quarter = CASE 
  WHEN EXTRACT(MONTH FROM Order_Date) IN (1, 2, 3) THEN 'Q1'
  WHEN EXTRACT(MONTH FROM Order_Date) IN (4, 5, 6) THEN 'Q2'
  WHEN EXTRACT(MONTH FROM Order_Date) IN (7, 8, 9) THEN 'Q3'
  ELSE 'Q4'
END
WHERE true;

SELECT year, quarter, sum(sales) AS total_sales, SUM(profit) as total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY year, quarter
ORDER BY year, quarter;

SELECT quarter AS Quarters_2014_2017, SUM(sales) AS Total_sales, SUM(profit) as total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY quarter
ORDER BY quarter;

--3. What region generates the highest sales and profits?
SELECT region, sum(sales) AS total_sales, sum(profit) AS total_profit
FROM Superstore_sales.raw_data
GROUP BY region
ORDER BY total_profit DESC;

SELECT region, ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY region
ORDER BY profit_margin DESC;

--4. What state and city brings in the highest sales and profits?

--states

SELECT state, SUM(sales) AS total_sales, sum(profit) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY State
ORDER BY total_profit DESC
LIMIT 10;


SELECT state, SUM(sales) AS total_sales, sum(profit) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY State
ORDER BY total_profit ASC
LIMIT 10;

--cities

SELECT city, SUM(sales) AS total_sales, sum(profit) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY city
ORDER BY total_profit DESC
LIMIT 10;


SELECT City, SUM(sales) AS total_sales, sum(profit) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY city
ORDER BY total_profit ASC
LIMIT 10;


--5. Relationship between discount and sales and the total discount per category

SELECT discount, avg(sales) AS avg_sales
FROM Superstore_sales.raw_data
GROUP BY discount
ORDER BY discount;

SELECT discount, avg(sales) AS avg_sales
FROM Superstore_sales.raw_data
GROUP BY discount
ORDER BY avg_sales DESC;

SELECT category, MAX(discount) AS total_discount
FROM `Superstore_sales.raw_data`
group by Category
order by total_discount DESC;

SELECT category, Sub_Category, MAX(discount) AS total_discount
FROM `Superstore_sales.raw_data`
group by Category, Sub_Category
order by total_discount DESC;

--6. What category generates the highest sales and profits in each region and state?

SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit, ROUND(sum(profit)/sum(sales)*100,2) AS profit_margin
FROM `Superstore_sales.raw_data`
GROUP BY Category
ORDER BY total_profit DESC;

SELECT  Region, Category, sum(sales) AS total_sales, sum(profit) AS total_profit
FROM `Superstore_sales.raw_data`
GROUP BY region, Category
ORDER BY total_profit DESC;

SELECT  State, Category, sum(sales) AS total_sales, sum(profit) AS total_profit
FROM `Superstore_sales.raw_data`
GROUP BY State, Category
ORDER BY total_profit DESC;

--7. What sub_category generates the highest sales and profits in each region and state?

SELECT sub_category, sum(sales) AS total_sales, SUM(profit) AS total_profit, round(sum(profit)/sum(sales)*100,2) AS profit_margin
FROM `Superstore_sales.raw_data`
group by Sub_Category
order by total_profit DESC;

SELECT region, sub_category, sum(sales) AS total_sales, SUM(profit) AS total_profit
FROM `Superstore_sales.raw_data`
group by region, Sub_Category
order by total_profit DESC;

SELECT State, sub_category, sum(sales) AS total_sales, SUM(profit) AS total_profit
FROM `Superstore_sales.raw_data`
group by State, Sub_Category
order by total_profit DESC;

--8. What are the most and the least profitable products?

SELECT product_name, SUM(sales) AS total_sales, SUM(Profit) AS total_profit
FROM `Superstore_sales.raw_data`
group by Product_Name
order by total_profit DESC;

SELECT product_name, SUM(sales) AS total_sales, SUM(Profit) AS total_profit
FROM `Superstore_sales.raw_data`
WHERE Profit IS NOT NULL
group by Product_Name
order by total_profit ASC;

--9. What segment makes the most of our products and sales?

SELECT segment, sum(sales) as total_sales, sum(profit) AS total_profit
FROM `Superstore_sales.raw_data`
group by Segment
order by total_profit DESC;

--10. How many customers are in total and how much per region and state?

SELECT COUNT(distinct customer_id) AS total_customers
FROM `Superstore_sales.raw_data`;

SELECT Region, count(distinct Customer_ID) AS total_customers
FROM `Superstore_sales.raw_data`
group by Region
order by total_customers DESC;

SELECT State, count(distinct Customer_ID) AS total_customers
FROM `Superstore_sales.raw_data`
group by State
order by total_customers DESC;

--11. Customer rewards program

SELECT Customer_ID, SUM(sales) AS total_sales, SUM(Profit) AS total_profit
FROM `Superstore_sales.raw_data` 
group by Customer_ID
order by total_sales DESC
LIMIT 15;

--12. Average shipping time per class in total

SELECT DATE_DIFF(ship_date, order_date, DAY) AS avg_shipping_time
FROM `Superstore_sales.raw_data`
LIMIT 1;

/*ALTER TABLE `Superstore_sales.raw_data`
ADD COLUMN avg_shipping_time INT;

UPDATE `Superstore_sales.raw_data`
SET avg_shipping_time = DATE_DIFF(ship_date, order_date, DAY)
WHERE true;

SELECT ship_mode, avg_shipping_time
from `Superstore_sales.raw_data`
group by Ship_Mode, avg_shipping_time
order by avg_shipping_time DESC;*/

SELECT Ship_Mode, avg(DATE_DIFF(Ship_Date, Order_Date, day)) AS avg_shipping_time
FROM `Superstore_sales.raw_data`
GROUP BY Ship_Mode
ORDER BY avg_shipping_time;

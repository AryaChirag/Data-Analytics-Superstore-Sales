# Data Analytics for Superstore Sales

## Goal of the project

The purpose of this project is to identify the patterns in products, regions, categories, and customer segments for efficiency and profit optimization. Main Business Objectives are:
+ How can we optimize our profits?
+ What are the emerging trends that we can identify?
+ How can we take these insights to build recommendations?

 A Sales Dashboard from company data is developed using **Tableau** and the data analysis is done using **SQL** to answer the above business objectives, while **Excel** will serve as the first repository for data.

## Tableau Dashboard

The interactive Dashboard based upon Yearly and Quarterly sales aspects from 2014-2017 of collected data is shown in the image below while the subsequent link is also attached:

![Dashboard](media/Superstore_Dashboard.png)

Click [here](https://public.tableau.com/app/profile/chirag.arya4385/viz/SuperstoreDashboard_16958486880750/SuperstoreDashboard?publish=yes) for interactive tableau dashboard.

The other part of this dynamic Dashboard based upon the top 5 Customers, Products, and Cities in terms of total sales from 2014-2017 of collected data is shown in the image below with a subsequent link:

![Dashboard2](media/Top_5_sale_results.png)

Click [here](https://public.tableau.com/app/profile/chirag.arya4385/viz/Top5saleresults/Top5saleresults?publish=yes) for the above tableau dashboard.

## Data Processing

Data will be processed and cleaned with the help of Excel by observing:
+ Check for missing data with the help of conditional formatting
+ Remove duplicate rows
+ Correctly format columns for easy SQL analysis

## Analysis Approach

The following set of questions and topics will be stringed out from the data.\
Let’s load data into Google Big Query and check the first 5 rows to make sure it is imported well.

In the following code 'Propane-choir-395311' is the user profile, 'Superstore_sales' is the dataset name, and 'raw_data' is the table name.

```SQL
SELECT * 
FROM `propane-choir-395311.Superstore_sales.raw_data` LIMIT 5;
```
### 1. What are the total sales and total profits of each year?

First create a year column from Date, which will be further used in the analysis of data.
> To create a new column for the year

``` SQL
SELECT EXTRACT(Year From Order_Date) As year
FROM `Superstore_sales.raw_data`;

ALTER TABLE `Superstore_sales.raw_data`
ADD COLUMN year INT;

UPDATE `Superstore_sales.raw_data`
SET year = EXTRACT(YEAR FROM Order_Date)
WHERE true;
```
> To find the total sales and profit in each year
```SQL
SELECT year, ROUND(SUM(Sales),3) AS total_sales, ROUND(SUM(profit),3) AS total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY year
ORDER BY year ASC;
```
This query produced the following result:

![1](media/1.png)

The data above shows how the profits over the years have steadily increased with each proceeding year being more profitable than the other despite having a fall in sales in 2015.

### 2. What are the total profits and total sales per quarter?

>To create a new column for the quarter

``` SQL
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

ALTER TABLE `Superstore_sales.raw_data`
ADD COLUMN quarter STRING;

UPDATE `Superstore_sales.raw_data`
SET quarter = CASE 
  WHEN EXTRACT(MONTH FROM Order_Date) IN (1, 2, 3) THEN 'Q1'
  WHEN EXTRACT(MONTH FROM Order_Date) IN (4, 5, 6) THEN 'Q2'
  WHEN EXTRACT(MONTH FROM Order_Date) IN (7, 8, 9) THEN 'Q3'
  ELSE 'Q4'
END
WHERE true;
```

> To find the total sales and profit in each quarter
```SQL
SELECT year, quarter, ROUND(sum(sales),3) AS total_sales, ROUND(SUM(profit),3) as total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY year, quarter
ORDER BY year, quarter;
```
This query produced the following result:

![2](media/2.png)

> To find the quarters performance from 2014-2017
```SQL
SELECT quarter AS Quarters_2014_2017, ROUND(SUM(sales),3) AS Total_sales, ROUND(SUM(profit),3) as total_profit
FROM `propane-choir-395311.Superstore_sales.raw_data`
GROUP BY quarter
ORDER BY quarter;
```
>This query gives us the following results:

![2a](media/2a.png)

*Quarters performance from 2014–2017*

The result above shows that the period of October, November, and December are the best-selling months with the most profit.

### 3. What region generates the highest sales and profits?

>To find the total sales and profit with respect to the region

```SQL
SELECT region, ROUND(sum(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM Superstore_sales.raw_data
GROUP BY region
ORDER BY total_profit DESC;
```
This query produced the following result:

![3](media/3.png)

It can be observed that the West region is the one with the most sales and brings in the highest profits. The East region is pretty good-looking. Those 2 regions are definitely areas of interest if the company wants to maximize our profits and expand business. Concerning the South region, it doesn't gain a lot of revenue but still, the profits are there. It is the Central region that is quite alarming as it generates way more revenue than the South region but does not make at least the same profits over there. The Central region should be the one on the watchlist.

> Let’s observe each region's profit margins for further analysis with the following code:

``` SQL
SELECT region, ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY region
ORDER BY profit_margin DESC;
```
This query produced the following result:

![3a](media/3a.png)

Profit margins are a measure of a company’s profitability and are expressed as the percentage of revenue that the company keeps as profit. So It can be seen that the West and East are really good. The South region despite almost selling less than half of the West region in revenue has a good profit margin of 11.93% which is great. However, the Central region is still not convincing.

### 4. What state and city brings in the highest sales and profits?

#### States

Which states are the top and bottom 10 in terms of total sales, profit, and profit margin?

> For top 10 states, it can be found with the following code:

``` SQL
SELECT state, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY State
ORDER BY total_profit DESC
LIMIT 10;
```

This query produced the following result:

![4](media/4.png)

> For the bottom 10 states, it can be found with the following code:

``` SQL
SELECT state, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY State
ORDER BY total_profit ASC
LIMIT 10;
```

This query produced the following result:

![4a](media/4a.png)

Our least profitable markets are listed above. The top 3 are Texas, Ohio, and Pennsylvania. 

#### Cities

Which cities are the top and bottom 10 in terms of total sales, profit, and profit margin?

> For top 10 cities, it can be found with the following code:

``` SQL
SELECT city, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY city
ORDER BY total_profit DESC
LIMIT 10;
```

This query produced the following result:

![4b](media/4b.png)

The top 3 cities that we should focus on are New York City, Los Angeles, and Seattle.

> For bottom 10 cities, it can be found with the following code:

``` SQL
SELECT City, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit,
  ROUND((SUM(profit)/sum(sales))*100,2) AS profit_margin
FROM Superstore_sales.raw_data
GROUP BY city
ORDER BY total_profit ASC
LIMIT 10;
```

This query produced the following result:

![4c](media/4c.png)

The bottom 3 are Philadelphia, Houston, and San Antonio.

### 5. The relationship between discount and sales and the total discount per category.

> For observing the correlation between discount and average sales.

```SQL
SELECT CONCAT(ROUND(discount * 100),'%') AS discount, ROUND(avg(sales),3) AS avg_sales
FROM Superstore_sales.raw_data
GROUP BY discount
ORDER BY discount;
```

This query produced the following result:

![5](media/5.png)

Seems that for each discount point, the average sales seem to vary a lot.

> To find the highest discount rate for average sales

```SQL
SELECT CONCAT(ROUND(discount * 100),'%') AS discount, ROUND(avg(sales),3) AS avg_sales
FROM Superstore_sales.raw_data
GROUP BY discount
ORDER BY avg_sales DESC;
```
This query produced the following result:

![5a](media/5a.png)

They almost have no linear relationship. However, it is at least observed that at a 50% discount, average sales are the highest it can be.

> For observing the total discount per product category.

```SQL
SELECT category, CONCAT(ROUND(MAX(discount)*100), '%') AS total_discount
FROM `Superstore_sales.raw_data`
group by Category
order by total_discount DESC;
```
This query produced the following result:

![5b](media/5b.png)

So Office supplies are the most discounted items followed by Furniture and Technology.

> To zoom in the category section to see exactly what type of products are the most discounted.

```SQL
SELECT category, Sub_Category, CONCAT(ROUND(MAX(discount)*100), '%') AS total_discount
FROM `Superstore_sales.raw_data`
group by Category, Sub_Category
order by total_discount DESC;
```
This query produced the following result:

![5c](media/5c.png)

Binders, Phones, and Furnishings are the most discounted items.

### 6. What category generates the highest sales and profits in each region and state?

> To observe the total sales and total profits of each category with their profit margins:

```SQL
SELECT category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit, ROUND(sum(profit)/sum(sales)*100,2) AS profit_margin
FROM `Superstore_sales.raw_data`
GROUP BY Category
ORDER BY total_profit DESC;
```
This query produced the following result:

![6](media/6.png)

Out of the 3, it is clear that Technology and Office Supplies are the best in terms of profits. Plus they seem like a good investment because of their profit margins. Furniture is still making profits but does not convert well overall.

> To observe the highest total sales and total profits per Category in each region:

```SQL
SELECT  Region, Category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
GROUP BY region, Category
ORDER BY total_profit DESC;
```
This query produced the following result:

![6a](media/6a.png)

These are the best categories in terms of total profits in each region. The West is in the top 3 two times with Office Supplies and Technology and the East with Technology. Among the total profits, the only one that fails to break even is the Central Region with Furniture where it is operated at a loss when selling it there.

> To see the highest total sales and total profits per Category in each state:

```SQL
SELECT  State, Category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
GROUP BY State, Category
ORDER BY total_profit DESC;
```
This query produced the following result:

![6b](media/6b.png)

The table above shows the highest-performing categories in each state. Technology in New York and Washington and Office Supplies in California. The 3 categories are all around good for the top 3 markets except the furniture category in Washington which is good but not as great as the others.

### 7. What subcategory generates the highest sales and profits in each region and state?
> To observe the total sales and total profits of each subcategory with their profit margins:
```SQL
SELECT sub_category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit, round(sum(profit)/sum(sales)*100,2) AS profit_margin
FROM `Superstore_sales.raw_data`
group by Sub_Category
order by total_profit DESC;
```

This query produced the following result:

![7](media/7.png)

Out of a total of 17 subcategories nationwide, the biggest profits come from Copiers, Phones, Accessories, and Paper. The profits and profit margins on Copiers and Papers especially are interesting in the long run. Losses came from Tables, Bookcases, and Supplies where the company is incapable of breaking even.

> To see the highest total sales and total profits per subcategory in each region:

```SQL
SELECT region, sub_category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
group by region, Sub_Category
order by total_profit DESC;
```
This query produced the following result:

![7a](media/7a.png)

The above displays the best subcategories per region.

> To see the highest total sales and total profits per subcategory in each state:

```SQL
SELECT State, sub_category, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
group by State, Sub_Category
order by total_profit DESC;
```
This query produced the following result:

![7b](media/7b.png)

Machines, Phones, and Binders perform very well in New York. Followed by Accessories and Binders in California and Michigan respectively.

### 8. What are the names of the products that are the most and least profitable to us?

> To get the most profitable products, the following query is made:

```SQL
SELECT product_name, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
group by Product_Name
order by total_profit DESC;
```
This query produces the following results:

![8](media/8.png)

These Copiers, Machines, and Printers are definitely the main foundations of profits. The Canon imageClass 2200 Advanced Copier, Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind, and the Hewlett Packard LaserJet 3310 Copier are top 3.

> To get the least profitable products, the following query is made:

```SQL
SELECT product_name, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
WHERE Profit IS NOT NULL
group by Product_Name
order by total_profit ASC;
```
This query produces the following results:

![8a](media/8a.png)

The Cubify CubeX 3D Printer Double Head Print, Lexmark MX611dhe Monochrome Laser Printer, and the Cubify CubeX 3D Printer Triple Head Print are the products that operate the most at a loss.

### 9. What segment makes the most of our profits and sales?

> This can be verified with the help of the following query:

```SQL
SELECT segment, ROUND(SUM(sales),3) AS total_sales, ROUND(sum(profit),3) AS total_profit
FROM `Superstore_sales.raw_data`
group by Segment
order by total_profit DESC;
```

The above query produces the following results:

![9](media/9.png)

The consumer segment brings in the most profit followed by the Corporate and then the Home office.

### 10. How many customers do we have in total and how much per region and state?

> Total number of customers can be found by:

```SQL
SELECT COUNT(distinct customer_id) AS total_customers
FROM `Superstore_sales.raw_data`;
```
The above query produces the following results:

![10](media/10.png)

The company had 793 customers between 2014 and 2017.

> Total number of customers based on region:

```SQL
SELECT Region, count(distinct Customer_ID) AS total_customers
FROM `Superstore_sales.raw_data`
group by Region
order by total_customers DESC;
```
The above query produces the following results:

![10a](media/10a.png)

The company had customers moving around regions which explains why they all do not add up to 793. Since there could be double counting. The West is the area where it has the biggest market of all.

> Total number of customers based upon state:

```SQL
SELECT State, count(distinct Customer_ID) AS total_customers
FROM `Superstore_sales.raw_data`
group by State
order by total_customers DESC;
```
The above query produces the following results:

![10b](media/10b.png)

The company has the most customers in California, New York, and Texas.

### 11. Customer rewards program

To build a loyalty and rewards program in the future. What customers spent the most with the company? That generated the most sales. It is always important to cater to the best customers and see how the company can provide more value to them as it is cheaper to keep a current customer than it is to acquire a new one.

> To check the customers with the most business and profit with the company:

```SQL
SELECT Customer_ID, ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM `Superstore_sales.raw_data` 
group by Customer_ID
order by total_sales DESC
LIMIT 15;
```
The above query produces the following results:

![11](media/11.png)

The display of the customer names is on file but showing the unique customer ID is a form of pseudonymization for security reasons. What is actually interesting to see is that customer ID ‘SM-20320’ is the customer who spent the most but is not bringing the most profit. But the company still has to reward his/her loyalty. It is customer ID ‘TC-20980’ who is second in the list but brings the most profit.

### 12. Average shipping time per class and total

> To find the average shipping time regardless of the shipping mode:

```SQL
SELECT DATE_DIFF(ship_date, order_date, DAY) AS avg_shipping_time
FROM `Superstore_sales.raw_data`
LIMIT 1;
```

The above query produces the following results:

![12](media/12.png)

> To find the shipping time in each shipping mode:

```SQL
SELECT Ship_Mode, CAST(avg(DATE_DIFF(Ship_Date, Order_Date, DAY)) AS INT64) AS avg_shipping_time
FROM `Superstore_sales.raw_data`
GROUP BY Ship_Mode
ORDER BY avg_shipping_time;
```
The above query produces the following results:

![12a](media/12a.png)

Data shows, on average it takes 5 days to deliver products to customers on standard class.

## Datasets Used
The datasets used:
+ Comes with 9995 rows with 9994 being pure data and the other one row being the column headers.
+ This company sales data recorded between 3rd of January to 5th if January 2018.
+ It contains the data of 793 customers.
+ The data is publicly available through Kaggle under https://www.kaggle.com/datasets/vivek468/superstore-dataset-final

## Built with
+ Google Bigquery
+ Tableau

## Authors
+ Chirag Arya - [Github Profile](https://github.com/AryaChirag)

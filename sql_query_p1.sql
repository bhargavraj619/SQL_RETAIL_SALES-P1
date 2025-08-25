--sql retail sales analysis-- p1
create database sql_projectp2;

--create table--
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
( 
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit INT,
	cogs FLOAT,
	total_sale FLOAT);

--DATA CLEANING--

SELECT count(*) FROM retail_sales

SELECT * FROM retail_sales
where 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

	

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
	
SELECT COUNT(*) FROM retail_sales;


--DATA EXPLORATION--
--HOW MANY SALES WE HAVE --

SELECT COUNT(*) AS TOTAL_SALE FROM retail_sales;

--how many UNIQUE customers we have--

SELECT COUNT(DISTINCT(customer_id)) AS TOTAL_SALES  FROM retail_sales;

--HOW MANY unique CATEGORIES

SELECT DISTINCT(CATEGORY) FROM retail_sales;

--data analysis & business key problems and answers

--Q1 write a sql query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

--q2 write a sql query to retrieve all transaction where the category is clothing 
--and the quantities sold is >=4 in the month of NOV-22

SELECT category,SUM(quantiy) FROM retail_sales
WHERE category = 'Clothing'
GROUP BY 1

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

--q3 write a sql query to calculate the total sales for each category

SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;


--q.4 write a sql query to find the average age of customers who purchased items from beauty category


SELECT
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--q5 write a sql query to find all transaction where the total_sale is greater than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000

--q6write a sql query to find the total no of transactions (transaction_id )made by each gender in each category

SELECT
	Category,
	gender,
	COUNT(*) as total_trans
from retail_sales
GROUP
	BY
	category,
	gender
ORDER BY 1

--Q7WRITE A SQL QUERY to calculate the average sale for each month,find out best selling month in each year
SELECT 
		year,
		month,
		avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(
			PARTITION BY EXTRACT(YEAR FROM sale_date)
			ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1;
-- ORDER BY 1,3 DESC
--Q8 WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES

SELECT * FROM retail_sales

SELECT customer_id,SUM(total_sale) as TOTAL_SALES
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q9)WRITE A SQL QUERY TO FIND THE NO OF UNIQUE CUSTOMERS  WHO PURCHASED ITEMS FROM EACH CATEGORY

SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--q10) write a sql query to create each shift and number of orders (example morning <=12, Afternoon between 12 & 17, evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--END OF PROJECT
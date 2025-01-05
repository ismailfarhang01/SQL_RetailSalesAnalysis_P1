-- SQL Retail Sales Analysis
CREATE DATABASE RetailSale_SQL_Project1;

-- Create table
drop table if exists retail_sales;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(6),
	age INT,
	category VARCHAR(20),
	quantiy FLOAT,
	price_per_unit INT,
	cogs FLOAT,
	total_sale FLOAT
)

select * from retail_sales
limit 10;

select count(*) as total_count
from retail_sales;

-- Data Cleaning
SELECT *
FROM retail_sales
WHERE
	transactions_id IS NULL
OR	
	sale_date IS NULL
OR	
	sale_time IS NULL	
OR	
	customer_id IS NULL	
OR	
	gender IS NULL
OR	
	age IS NULL
OR	
	category IS NULL
OR	
	quantiy IS NULL
OR	
	price_per_unit IS NULL
OR	
	cogs IS NULL
OR	
	total_sale IS NULL

-- Deleting null values
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
OR	
	sale_date IS NULL
OR	
	sale_time IS NULL	
OR	
	customer_id IS NULL	
OR	
	gender IS NULL
--OR	
--	age IS NULL
OR	
	category IS NULL
OR	
	quantiy IS NULL
OR	
	price_per_unit IS NULL
OR	
	cogs IS NULL
OR	
	total_sale IS NULL;

-- Updating values on age column
UPDATE retail_sales 
SET age = 38
WHERE transactions_id = 921;

-- Data Exploration
-- how many sales do we have?
SELECT COUNT(total_sale) as total_sale
FROM retail_sales;

-- how many unique customers do we have?
SELECT COUNT(distinct customer_id) as Unique_Cs
FROM retail_sales;

-- how many categories do we have?
SELECT COUNT(distinct category) as cnt_category
FROM retail_sales;

-- Data Analysis based on Business Key Problems and Answers
-- Q1. Write a query to retrieve all columns for sales date on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a query to retrieve all transactions where the category is clothing 
-- and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy > 3;

-- Q3. Write a query to calculate the total sales and total orders for each category
SELECT
	category,
	COUNT(total_sale) as total_orders,
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1;

-- Q4. Write a query to find the average age of customers who purchased items from the Beauty of category.
SELECT
	round(AVG(age),2) as avg_age_cs
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Write a query to find all transactions where the total sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- Q6. Write a query to find the total number of transactions made by each gender in each category.
SELECT 
	category,
	gender,
	SUM(transactions_id) as total_trans
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;

-- Q7. Write a query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT 
	year,
	month,
	avg_sales
FROM	
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank = 1;

-- Q8. Write a query to find the top 5 customers based on the highest total sales
SELECT customer_id, sale_date, gender, age, total_sale
FROM retail_sales
ORDER BY total_sale DESC
LIMIT 5;

-- Q9. Write a query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_uniq_cs
FROM retail_sales
GROUP BY 1;

-- Q10. Write a query to create each shift and number of orders (E.g. Morning <12, Afternoo BTN 12 & 17, Evening >17)
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
GROUP BY shift;

-- End of Projects


-- SQL PROJECT RETAIL SALES ANALYSIS

CREATE DATABASE sql_project;

USE sql_project;

CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY, 
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR (15),
age	INT,
category VARCHAR (20),	
quantity INT,
price_per_unit FLOAT,	
cogs FLOAT,	
Total_sale FLOAT
);

SELECT * FROM retail_sales;

-- DATA EXPLORATION


-- How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

-- How many unique category we have?
SELECT COUNT(DISTINCT category) as total_category FROM retail_sales;


-- DATA ANALYSIS & BUSINESS SOLUTIONS 

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than or equals to 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
AND quantity >= 4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales and total orders for each category
SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total sales is greater than 10000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender,
COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. FInd out best selling month in each year
SELECT
    year,
    month,
    total_sales
FROM (
SELECT
     YEAR(sale_date) as year,
	 MONTH(sale_date) as month,
     SUM(total_sale) as total_sales,
     RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS sale_rank
 FROM retail_sales
 GROUP BY 1, 2
 ) ranked_months
 WHERE sale_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total_sales
SELECT 
  customer_id,
  SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT
     category,
     COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (example morning <12, Afternoon Between 12 & 17, Evening > 17)
-- CTE Common table expression
WITH hourly_sale
AS
(
SELECT *,
     CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'AFTERNOON'
        ELSE 'EVENING'
	 END as shift
FROM retail_sales
)
SELECT 
 shift,
 COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;
    
    
-- END OF PROJECT








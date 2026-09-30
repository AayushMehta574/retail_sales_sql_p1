--create table
create table retail_sales (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id	INT,
gender varchar(15),
age INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit float,
cogs float,
total_sale float
);
select * from retail_sales;
SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

 --Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

   select transactions_id,total_sale from retail_sales
   where total_sale >=1000


   -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	select gender,
	      category,
		  count(*) as total_transaction 
		  
		  from
		     retail_sales
		  group 
		       by
			      gender,
				   category
				   order by 1
		 


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select
       year,
	       month,
		         avg_sale
				         from
						     (
select
      Extract (year from sale_date)as year,
	  extract(month from sale_date)as month,
	  avg(total_sale)as avg_sale,
	  rank() over(partition by extract (year from sale_date) order by avg(total_sale)DESC) as rank
	  from retail_sales
	  group by 1,2
	  ) as t1
	   where rank = 1
	  
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales


	select customer_id,
	sum(total_sale) as total_sale
	from retail_sales
	group by 1
	order by 2 DESC
	limit 5
	
	  
	  -- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

	  SELECT 
	          category,
			 count (  distinct customer_id) as unique_cus
			  from retail_sales
			  group by 1




--
--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
 with hourly_sale 
 as
 (
 select *,
 case
 when extract (hour from sale_time)< 12 then 'morning'
  when  extract(hour from sale_time)between 12 and 17 then 'Afternoon'
     else 'evening'
	 end as shift
	 from retail_sales
	) 
	select shift,
	      count(*) as total_orders
		  from hourly_sale
		  group by shift

 
 
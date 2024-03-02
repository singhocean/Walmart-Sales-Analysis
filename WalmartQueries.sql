-- Creating a Database if it does not exist in the system databases.
----------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name='WalmartSales')
  BEGIN
    CREATE DATABASE WalmartSales;
  END;
  GO

USE WalmartSales;

-- Creating a table in the database if it does not exist in the database.
--------------------------------------------------------------------------
IF OBJECT_ID(N'Wlmrtsales', N'U') IS NULL
BEGIN
 CREATE TABLE Wlmrtsales (
   invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
   branch VARCHAR(5) NOT NULL,
   city VARCHAR(30) NOT NULL,
   customer_type VARCHAR(30) NOT NULL,
   gender VARCHAR(15) NOT NULL,
   product_line VARCHAR(100) NOT NULL,
   unit_price DECIMAL(10, 2) NOT NULL,
   quantity INT NOT NULL,
   VAT FLOAT NOT NULL,
   total DECIMAL(12, 4) NOT NULL,
   date DATETIME NOT NULL,
   time TIME NOT NULL,
   payment_method VARCHAR(15) NOT NULL,
   cogs DECIMAL(10, 2) NOT NULL,
   gross_margin_pct FLOAT NOT NULL,
   gross_margin DECIMAL(12, 4) NOT NULL,
   rating FLOAT);
END;

-- Bulk insert into the above table
---------------------------------------
BULK INSERT Wlmrtsales
FROM 'D:\DATA ANALYTICS\Projects\Walmart Sales Analysis\WalmartSalesData.csv'
WITH (FORMAT = 'CSV'
      , FIRSTROW = 2
      , FIELDTERMINATOR = ','
      , ROWTERMINATOR = '0x0a');

-- Check the data.
SELECT * FROM Wlmrtsales;

-- Let's add a column to find out in which out of 3 times of a working day(Morning, Afternoon, Evening) most of the sales happened. Let's call the column as time_of_day:
-- However, first let's decide which duration we'll consider as 'Morning', 'Afternoon' and 'Evening'. 

SELECT time,
		(CASE
		    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
		END) AS time_of_day FROM Wlmrtsales;

-- Now let's go ahead and add this column to our table.
ALTER TABLE Wlmrtsales ADD time_of_day VARCHAR(20);

-- IF we check, this column is empty for now and will show NULL values.
SELECT time_of_day FROM Wlmrtsales;

--Let's add some data into this column.
UPDATE Wlmrtsales SET time_of_day = (CASE
		    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
		END);

-- Now let's check the same column again. We'll see Morning, Afternoon and Evening filled respectively according to hours.
SELECT time, time_of_day FROM Wlmrtsales;

-- Let's add columns for day names (Mon, Tue, Wed, Thur, Fri) and month names (Jan, Feb, Mar) so that we can also find how was sales on which day and in which month.
-- day names
SELECT date,
DATENAME(weekday, date) AS day_name FROM Wlmrtsales;

ALTER TABLE	Wlmrtsales ADD day_name VARCHAR(10);

UPDATE Wlmrtsales SET day_name = (DATENAME(weekday, date));

-- month names
SELECT date,
DATENAME(month, date) AS month_name FROM Wlmrtsales;

ALTER TABLE Wlmrtsales ADD month_name VARCHAR(20);

UPDATE Wlmrtsales SET month_name = (DATENAME(month, date));
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Now let's look at the 'Business Questions'.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------Generic Questions----------------------------------------------------------------------------------------------------------------------------------
--1. How many unique cities does the data have?
SELECT DISTINCT(city) AS unique_cities FROM Wlmrtsales;

--2. In which city is each branch?
-- First let's find out how many unique branches are there.
SELECT DISTINCT(branch) FROM Wlmrtsales;
-- To answer the question:
SELECT DISTINCT city, branch FROM Wlmrtsales;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------Product Related Questions-------------------------------------------------------------------------------------------------------------------------
--1. How many unique product lines does the data have?
SELECT DISTINCT product_line FROM Wlmrtsales;
SELECT COUNT(DISTINCT product_line) AS unique_products FROM Wlmrtsales;

--2. What is the most common payment method?
-- Let's first see what are the payment method options available in the data.
SELECT DISTINCT payment_method FROM Wlmrtsales; 
-- To answer the question
SELECT payment_method, COUNT(payment_method) AS max_count FROM Wlmrtsales GROUP BY payment_method ORDER BY max_count DESC;  

--3. What is the most selling product line?
SELECT product_line, COUNT(product_line) AS max_product_count FROM Wlmrtsales GROUP BY product_line ORDER BY max_product_count DESC;

--4. What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue_of_month FROM Wlmrtsales GROUP BY month_name ORDER BY total_revenue_of_month DESC;

--5. Which month has the largest COGS?
SELECT month_name, SUM(cogs) AS cogs_of_month FROM Wlmrtsales GROUP BY month_name ORDER BY cogs_of_month DESC;

--6. What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue_of_product FROM Wlmrtsales GROUP BY product_line ORDER BY total_revenue_of_product DESC;

--7. What is the city with the largest revenue?
SELECT city, SUM(total) AS total_revenue_of_city FROM Wlmrtsales GROUP BY city ORDER BY total_revenue_of_city DESC;

--8. What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS total_VAT_of_product FROM Wlmrtsales GROUP BY product_line ORDER BY total_VAT_of_product DESC;

--9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.
SELECT product_line, cogs,
		            CASE
			              WHEN cogs > (SELECT AVG(cogs) FROM Wlmrtsales) THEN 'Good'
			              ELSE 'Bad'
		             END AS Product_Status FROM Wlmrtsales;

--10. Which branches sold more products than average product sold?
SELECT branch, COUNT(quantity) AS Products_sold FROM Wlmrtsales GROUP BY branch HAVING COUNT(quantity) > AVG(quantity);

--11. What is the most common product line by gender?
SELECT gender, product_line, COUNT(product_line) AS most_com_product FROM Wlmrtsales GROUP BY gender, product_line ORDER BY most_com_product DESC;

--12. What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating FROM Wlmrtsales GROUP BY product_line ORDER BY avg_rating DESC; 


---------------------Sales Related Questions-------------------------------------------------------------------------------------------------------------------------
--1. Number of sales made in each time of the day per weekday.
SELECT day_name, time_of_day, COUNT(quantity) AS num_of_sales FROM Wlmrtsales GROUP BY day_name, time_of_day ORDER BY num_of_sales DESC;

--2. Which of the customer type brings the most revenue?
--Let us first see the different customer types.
SELECT DISTINCT customer_type FROM Wlmrtsales;
--Now answer to the question.
SELECT customer_type, SUM(total) AS revenue FROM Wlmrtsales GROUP BY customer_type ORDER BY revenue DESC;

--3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city, SUM(VAT) AS tax FROM Wlmrtsales GROUP BY city ORDER BY tax DESC;

--4. Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS V_A_T FROM Wlmrtsales GROUP BY customer_type ORDER BY V_A_T DESC;


---------------------Customer Related Questions-------------------------------------------------------------------------------------------------------------------------
--1. How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM Wlmrtsales;

--2. How many unique payment methods does the data have?
SELECT DISTINCT payment_method FROM Wlmrtsales;

--3. What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS most_common_customer FROM Wlmrtsales GROUP BY customer_type ORDER BY most_common_customer DESC;

--4. Which customer type buys the most?
SELECT customer_type, COUNT(quantity) AS Buy FROM Wlmrtsales GROUP BY customer_type ORDER BY Buy DESC;

--5. What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS gender_count FROM Wlmrtsales GROUP BY gender ORDER BY gender_count DESC;

--6. What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_distribution FROM Wlmrtsales GROUP BY branch, gender ORDER BY gender_distribution DESC;

--7. Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS number_of_ratings FROM Wlmrtsales GROUP BY time_of_day ORDER BY number_of_ratings DESC; 

--8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, COUNT(rating) AS number_of_ratings FROM Wlmrtsales GROUP BY time_of_day, branch ORDER BY number_of_ratings DESC;

--9. Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating FROM Wlmrtsales GROUP BY day_name ORDER BY avg_rating DESC;

--10. Which day of the week has the best average ratings per branch?
SELECT day_name, branch, AVG(rating) AS avg_rating FROM Wlmrtsales GROUP BY day_name, branch ORDER BY avg_rating DESC;
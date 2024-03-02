# Walmart-Sales-Analysis
## Overview
The aim of this project is to explore the Walmart Sales data to understand top performing branches and products, sales trend of different products, customer behaviour. The dataset given is of 45 Walmart stores located in different regions adn each store contains many departments. Selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and to what extent.

## Data Source
The dataset is obtained from Kaggle Walmart Sales Forecasting Competition:
[https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting]

## Dataset Description
| Column Name             | Column Description                      |
| :---------------------- | :-------------------------------------- |
| invoice_id              | ID of the invoice for the sales made    |
| branch                  | Name of the branch                      |
| city                    | Location of the branch                  |
| customer_type           | Type of customers who made purchase     |
| gender                  | Gender of customers who made purchase   |
| product_line            | Product type of the product sold        |
| unit_price              | Price of each product                   |
| quantity                | Quantity of the product sold            |
| VAT                     | Amount of tax on purchase               |
| total                   | Total cost of the purchase              |
| date                    | Date on which the purchase was made     |
| time                    | Time at which the purchase was made     |
| payment_method          | Method using which payment was done     |
| cogs                    | Cost Of Goods sold                      |
| gross_margin_percentage | Gross margin percentage                 | 
| gross_income            | Gross Income                            |
| rating                  | Rating                                  |

## Tools
- Microsoft Excel - For data cleansing.
- Microsoft SQL Server - For exploratory data analysis.

## Types of Analysis to be performed
1. Product Analysis
-> This analysis aims to understand different product lines, which of those are performing best and which ones need improvement.

2. Sales Analysis
-> This analysis aims to understand sales trends of products. This can help to measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.

3. Customer Analysis
-> This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.

## Business Questions to Answer
### Generic Questions
1. How many unique cities does the data have?
2. In which city is each branch?

### Product Analysis Questions
1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
7. What is the city with the largest revenue?
8. What product line had the largest VAT?
9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.
10. Which branch sold more products than average product sold?
11. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales Analysis Questions
1. Number of sales made in each time of the day per weekday.
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?
   
### Customer Analysis Questions
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day of the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?
-----------------------------------------------------------------------------------------------------------------------------------------------

## Steps taken to proceed for analysis
### 1. Data Wrangling:
Did inspection of data to make sure **NULL** values and missing values are detected. 

### 2. Build a Database.
### 3. Create a table and insert data.
There are no null values in our database as while creating the tables each field was set to **NOT NULL** and hence null values got filtered out.

### 4. Added some new columns from existing ones.
1. Add a new column named **'time_of_day'** to give insight of sales in the Morning, Afternoon and Evening. This helped answering questions like on which part of the day most sales are made.
2. Add a new column named **'day_name'** that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This helped answering questions like on which weekday each branch was mostly busy.
3. Add a new column named **'month_name'** that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Helped to determine which month of the year had the most sales and profit.

### 5. Exploratory Data Analysis (EDA):
Exploratory data analysis done to answer the Business questions listed in the Business Questions topic above. All the SQL queries written to answer those questions are in the **'WalmartQueries.sql'** file.




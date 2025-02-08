
# lets say my manager has asked me the report with the following requirement / fields 


-- ------------------------------------------------------------------

-- Month	
-- Product name
-- Variant
-- Sold Quantity
-- Gross price per item
-- Gross price total

-- aggregated on monthly basis on product level for FY = 2021 
-- customer name = croma


-- ------------------------------------------------------------------

# lets retrive customer info first 

select * from dim_customer where customer 
like "%croma%" and market = "India";


# lets use the dateaddd function

# 9-2020 -- > 1 2021
# 10-2020 --> 2 2021
	
select date_add("2020-09-01" , interval 4 month);



# lets retrive monthly aggregated for the fiscal year = 2021

select * from fact_sales_monthly
where customer_code = 90002002 
and YEAR(DATE_ADD(date, INTERVAL 4 MONTH)) = 2021
order by date;

# lets convert that into a function

select * from fact_sales_monthly
where customer_code = 90002002 and 
get_fiscal_year(date) = 2021 
order by date;

# exercise , lets retrive of only q4 of the fiscal year 

# logic 

SELECT month("2022-10-02"); 
SELECT month(curdate());
#
#        FOR 1 fiscal year
#
#        months 9 ,10 ,11 -> Q1            
#		 months 12, 1 , 2 -> Q2
#        months 3 , 4 , 5 -> Q3
#        months 6 , 7 , 8 -> Q4

select * from fact_sales_monthly
where customer_code = 90002002 and 
get_fiscal_year(date) = 2021  and get_fiscal_quarter(date) = "Q4"
order by date;


# lets retrive more two columns product and variant

select s.date, s.product_code, p.product, p.variant, 
s.sold_quantity from 
fact_sales_monthly s 
JOIN dim_product p 
ON s.product_code = p.product_code
WHERE
customer_code=90002002 AND 
get_fiscal_year(s.date)=2021     
LIMIT 1000000;

# now lets retrive the remaining columns , lets try to join all the columns first

select * from fact_sales_monthly s 
JOIN dim_product p on p.product_code = s.product_code
JOIN fact_gross_price g 
	on g.fiscal_year = get_fiscal_year(s.date)
    and g.product_code = p.product_code 
where customer_code=90002002 AND 
get_fiscal_year(s.date)=2021     
LIMIT 5000;

# now lets get the final report and execute the final query 

select s.date, s.product_code, p.product, p.variant, 
s.sold_quantity, g.gross_price,
ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total from 
fact_sales_monthly s 
JOIN dim_product p 
ON s.product_code = p.product_code
JOIN  fact_gross_price g 
on g.fiscal_year = get_fiscal_year(s.date)
and g.product_code = p.product_code
WHERE
customer_code=90002002 AND 
get_fiscal_year(s.date)=2021     
LIMIT 1000000;

-- -------------------------------------------------------------------------------


# lets say now we have a new task 
# gross montly total sales to croma

# meaning in which month how much sales is done with croma
# 2 columns are asked 

# months
# total gross sales 

-- -------------------------------------------------------------------------------

# lets fetch croma customer code 

select * from dim_customer where customer 
like "%croma%" and market = "India";

# lets fetch croma sales

select * from fact_sales_monthly 
where customer_code = 90002002;

# lets fetch gross sales as well

SELECT * from fact_gross_price;

# we remember product_code and fiscal_year is common lets join
select * from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002;

# we dont want all the columns so lets take the columns and arrange it in order
# lets also get the total gross sales like we did it in last query
 
select date , gross_price , (sold_quantity* gross_price) total_gross_price 
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
order by date asc;


# we got our columns but we can see we have multiple dates repeating , 
# because we have multiple products in same months , lets calc , we will have to group by 
# before group by we have to remember to apply a aggregate fucntion else we get random values lets see

select date , (sold_quantity* gross_price) total_gross_price 
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by s.date
order by date asc;


# see we are not getting the right values we are getting a random value ,
# lets apply aggregate function
select date , SUM(sold_quantity* gross_price) total_gross_price 
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by s.date
order by date asc;

## now we got it proper , we can round it 
select date , ROUND(SUM(sold_quantity* gross_price),0) total_gross_price 
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by s.date
order by date asc;


-- -------------------------------------------------------------------------------

## exercise
## Generate a yearly report for Croma India where there are two columns

-- 1. Fiscal Year
-- 2. Total Gross Sales amount In that year from Croma


select fiscal_year , 
ROUND(SUM(sold_quantity* gross_price),2) 
as fiscal_year_gross_sales
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by fiscal_year
order by date asc;

-- -------------------------------------------------------------------------------

# now my manager is like bro give me the same report for amaozon 
#  bro give me the same report for ebay and flipcart 
#  bro give me the same report for ezone

# and im like to my senior , please help me i am tired of doing this repetitive process everyday 
# my senoior said , do you know about stored procedures? , use them and thankme later

# so you get it that it gets too much sometimes that you have to 
# update this customer code and give it to your manager

# so you created a stored procedure which you can call and any other non technical person can too
# in you absence , since now its a part of your data base

-- --------------------------------------------------------------------------
# difference between stored procedure and function is that 

# function retunrs a single value , stored procedure is just like another query 
# it can return single , multiple values , tables , multiple queries as well
-- -----------------------------------------------------------------------------

call gdb0041.get_monthly_gross_sales_single(90002002);

## but if you check amaozon
# you will see you have multiple customer code 
# this can happen to to simple reason that 
# they were working together , then disconnected and then again working together 
# with new account , so how to save yourself from that 

# lets check amazon

select * from dim_customer where customer 
like "%amazon%" and market = "India";

# see we have 2

# lets create a stored procedure to solve this

## one way to do this in query is using " IN  " operator


select fiscal_year , 
ROUND(SUM(sold_quantity* gross_price),2) 
as fiscal_year_gross_sales
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code IN (90002008 ,90002016 )
group by fiscal_year
order by date asc;

select date , ROUND(SUM(sold_quantity* gross_price),0) total_gross_price 
from fact_sales_monthly s
join fact_gross_price g 
on g.product_code = s.product_code
and g.fiscal_year = get_fiscal_year(s.date)
where customer_code IN (90002008 ,90002016 )
group by s.date
order by date asc;


# but this wouldnt work in stored procedure because its returning a single INT value

# lets explore this new funtion , make sure you take care of the spacing

SELECT find_in_set(90002002 , "90002002,90002016");

#lets run our stored procedure for multiple values

call gdb0041.get_monthly_gross_sales_multiple('90002008 ,90002016');

-- -------------------------------------------------------------------------------

## lets explore more on stored procedures

# lets say my manager has asked me to 

## create a stored procedure that can determine the 
# market badget (gold or silver )with the following logic

# if total_sold_quantity > 5 mln 
# THEN market is gold else silver

# my inputs will be
## market 
## fiscal_year 

# output will be marktet_badge(gold / silver)

# so this way you will understand which market is making you max or min by fiscal_year

 -- -------------------------------------------------------------------------------

# EG : 

-- INDIA , 2020 --> GOLD
-- INONESIA , 2020 --> SILVER

 -- -------------------------------------------------------------------------------

# How ?  you have to find that out by total sold quantity

# lets fetch the relevant columns , we need sold_quanitty and markets

SELECT * from fact_sales_monthly ; 
SELECT * from dim_customer;

-- lets join these tables and get what we want
-- all we have to do is join these tables and figure out which market sold how much by group by

SELECT * from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where get_fiscal_year(s.date) = 2021 ;

## lets get rows where there is market and sold quantity

SELECT market , sold_quantity 
from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where get_fiscal_year(s.date) = 2021;


## now group by market to get total sold_quantity

SELECT market , sold_quantity 
from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where get_fiscal_year(s.date) = 2021
group by market;

## see its giving you random number because you didnt aggregate ,
## everytime you use group by you have to aggregate 

SELECT market , sum(sold_quantity) as total_qty
from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where get_fiscal_year(s.date) = 2021 
group by market;

-- --------------------------------------------------------------------

# we can also use CTE's

with abc as (SELECT market , sum(sold_quantity) as total_qty
from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where get_fiscal_year(s.date) = 2021 
group by market)

Select market from abc 
where total_qty > 5000000;



# if else as well
WITH abc AS (
    SELECT market, SUM(sold_quantity) AS total_qty
    FROM fact_sales_monthly s
    JOIN dim_customer c
    ON c.customer_code = s.customer_code
    WHERE get_fiscal_year(s.date) = 2022 
    GROUP BY market
)
SELECT market,
       CASE 
           WHEN total_qty > 5000000 THEN 'gold'
           ELSE 'silver'
       END AS market_category
FROM abc;



-- --------------------------------------------------------------------------

## perfect 

-- now you got for all the markets indian indonesia etc 

## lets say we want only one country

SELECT market , sum(sold_quantity) as total_qty
from fact_sales_monthly s
JOIN dim_customer c
ON c.customer_code = s.customer_code
where 
	get_fiscal_year(s.date) = 2021 
	and c.market = "India"
group by market;

## okay now lets create a stored procedure out of it

# paste this query there

# lets call out stored procedure 

set @out_badge = '0';
call gdb0041.get_market_badge('India', 2021, @out_badge);
select @out_badge;


-- -----------------------------------------------------------------------------------

# we have seen 

# input and output parameters
# how to convert aggregates into a new variable using INTO
# how to write if else statements 
# how to set default values
# comments

-- -----------------------------------------------------------------------------------

# benefits of stored procedures

-- 1 )  Convinience 
-- 2 ) 	Security
-- 3 ) 	Can often be used in data science notebooks
-- 4 )  Maintainablity
-- 5 )  Performance
-- 6 )  Developer Productivity


-- -----------------------------------------------------------------------------------


## learning sql is like swimming , you will have to dive in , you cant just read and chill

-- -----------------------------------------------------------------------------------











































































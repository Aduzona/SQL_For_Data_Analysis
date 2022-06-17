-- SQL Aggregation
/*

Count counts how many rows in a particular column.
Sum add together all of the value in a particular column
Min and Max returns lowest and highest value in a particular column.
Average calculates the average of all the values in a particular column

NULLs are a datatype that specifies where no data exists in SQL.
They are often ignored in our aggregation functions
NULL is different from zero or space.

For Parchposey, zero means no paper was sold, and 
NULL can mean no sales was attempted,  this can mean alot of difference.


*/

-- NULLs and Aggregation

/*

Notice that NULLs are different than a zero - they are cells where data does not exist.

When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.

NULLs - Expert Tip
There are two common ways in which you are likely to encounter NULLs:

NULLs frequently occur when performing a LEFT or RIGHT JOIN. You saw in the last lesson - when some rows in the left table of a left join are not matched with rows in the right table, those rows will contain some NULL values in the result set.


NULLs can also occur from simply missing data in our database.
*/

-- example
select *
from accounts
where primary_poc is NULL

-- COUNT
-- This counts all rows, 463
-- number of row of non NULL data
/*
COUNT the Number of Rows in a Table
Try your hand at finding the number of rows in each table. Here is an example of finding all the rows in the accounts table.

SELECT COUNT(*)
FROM accounts;
But we could have just as easily chosen a column to drop into the aggregation function:

SELECT COUNT(accounts.id)
FROM accounts;
These two statements are equivalent, but this isn't always the case, which we will see in the next video.
*/

select count(*) AS order_count
from orders 
where occurred_at >= '2016-12-01'
and occurred_at < '2017-01-01'


-- Count & Null
/*

count can help us identify the number of null values in any particular column
*/

-- this will count only non NULL values
select count(primary_poc) as account_count
from accounts
-- We can use the count function on any column in a table.

/*

Notice that COUNT does not consider rows that have NULL values. 
Therefore, this can be useful for quickly identifying which rows have missing data. You will learn GROUP BY in an upcoming concept, 
and then each of these aggregators will become much more useful.
*/

-- SUM
/*

As an inventory manager, and you are trying to do some inventory planning
and you want to know how much of each paper type to produce?

You can total up all sales of each paper type and compare them to one another.
do this using sum.

Pro Tip
You cannot use sum(*) the way you can use count(*)
SUM is only for columns that have quantitative data.
COUNT works on any column.

Unlike COUNT, you can only use SUM on numeric columns. However, SUM will ignore NULL values, as do the other aggregation functions you will see in the upcoming lessons.

Aggregation Reminder
An important thing to remember: aggregators only aggregate vertically - the values of a column. If you want to perform a calculation across rows, you would do this with simple [arithmetic](https://mode.com/sql-tutorial/sql-operators/#arithmetic-in-sql).

We saw this in the first lesson if you need a refresher, but the quiz in the next concept should assure you still remember how to aggregate across rows.
*/


Select sum(standard_qty) as standard,
sum(gloss_qty) as gloss,
sum(poster_qty) as poster

from orders

/*
QUIZ: SUM

Use the SQL environment below to find the solution for each of the following questions. If you get stuck or want to check your answers, you can find the answers at the top of the next concept.

1. Find the total amount of poster_qty paper ordered in the orders table.

2. Find the total amount of standard_qty paper ordered in the orders table.

3. Find the total dollar amount of sales using the total_amt_usd in the orders table.

4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

*/

-- 1. 
select sum(poster_qty) AS total_poster_sales
FROM orders;

-- 2. 
select sum(standard_qty) AS total_standard_sales
from orders;

-- 3.
select sum(total_amt_usd) AS total_dollar_sales
from orders;

-- 4.
/*
Notice, this solution did not use an aggregate.
*/
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

-- 5.
/*

Though the price/standard_qty paper varies from one order to the next. I would like this ratio across all of the sales made in the orders table.

Notice, this solution used both an aggregate and our mathematical operators
*/


select sum(standard_amt_usd)/sum(standard_qty) as ave_stand_amt
from orders;


-- MIN & MAX
/*

Notice that here we were simultaneously obtaining the MIN and MAX number of orders of each paper type. However, you could run each individually.

Notice that MIN and MAX are aggregators that again ignore NULL values. Check the expert tip below for a cool trick with MAX & MIN.

Expert Tip
Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns. Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”
*/
-- Example
select min(standard_qty) as standard_min,
min(gloss_qty) as gloss_min,
min(poster_qty) as poster_min,
max(standard_qty) as standard_max,
max(gloss_qty) as gloss_max,
max(poster_qty) as poster_max
from orders;

-- AVG
/*
Now we know the paper types are most popular(SUM) and we have a sence of
the largest order size that we might need to fullfill at any given time.
But what is the average order size, what can we expect to see on a regular basis?
We use the average function avg.

Similar to other software AVG returns the mean of the data - that is the sum of all of the values in the column divided by the number of values in a column. This aggregate function again ignores the NULL values in both the numerator and the denominator.

If you want to count NULLs as zero, you will need to use SUM and COUNT. However, this is probably not a good idea if the NULL values truly just represent unknown values for a cell.

MEDIAN - Expert Tip
One quick note that a median might be a more appropriate measure of center for this data, but finding the median happens to be a pretty difficult thing to get using SQL alone — so difficult that finding a median is occasionally asked as an interview question.
*/

/*
From the query below, it looks like the large poster paper (max), must have been a
major outlier because the average poster order is only about 2/5 of the size of
average standard order.
*/
select avg(standard_qty) as standard_avg, 
avg(gloss_qty) as gloss_avg,
avg(poster_qty) as poster_avg
from orders;
-- round it
select round(avg(standard_qty),0) as standard_avg, 
round(avg(gloss_qty),0) as gloss_avg,
round(avg(poster_qty),0) as poster_avg
from orders

/*
Questions: MIN, MAX, & AVERAGE
Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double check your solutions, my answers can be found at the top of the next concept.

1. When was the earliest order ever placed? You only need to return the date.

2. Try performing the same query as in question 1 without using an aggregation function.

3. When did the most recent (latest) web_event occur?

4. Try to perform the result of the previous query without using an aggregation function.

5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

6. Via the video(udacity), you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/

-- 1. 

select min(occurred_at) as earliest_order
from orders;

-- 2. 
select occurred_at as earliest_order
from orders
order by occurred_at
limit 1;

-- 3.
select max(occurred_at) as most_recent_event
from web_events;

-- 4. 
select occurred_at as most_recent_event
from web_events
order by occurred_at desc 
limit 1;

-- 5.
select avg(standard_amt_usd) as avg_stand_usd,
avg(standard_qty) as avg_stand_qty,
avg(gloss_amt_usd) avg_gloss_usd,
avg(gloss_qty) as avg_gloss_qty,
avg(poster_amt_usd) as avg_poster_usd,
avg(poster_qty) avg_poster_qty

from orders;

-- 6. 
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*
Since there are 6912 orders - we want the average of the 3457 and 3456
 order amounts when ordered. This is the average of 2483.16 and 2482.55.
  This gives the median of 2482.855. This obviously isn't an ideal way to
   compute. If we obtain new orders, we would have to change the limit. 
   SQL didn't even calculate the median for us. The above used a 
   SUBQUERY, but you could use any method to 
find the two necessary values, and then you just need the average of them.
*/

-- GROUP BY
/*
GROUP BY Note
Now that you have been introduced to JOINs, GROUP BY, and aggregate functions, the real power of SQL starts to come to life. Try some of the below to put your skills to the test!

Questions: GROUP BY
Use the SQL environment below to assist with answering the following questions. Whether you get stuck or you just want to double check your solutions, my answers can be found at the top of the next concept.

One part that can be difficult to recognize is when it might be easiest to use an aggregate or one of the other SQL functionalities. Try some of the below to see if you can differentiate to find the easiest solution.

1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.

3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.

4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

5. Who was the primary contact associated with the earliest web_event?

6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

*/

-- 1

-- placed the earliest order (the reason for order by)
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

--2 
-- for each account (thats why group by)

SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

--3

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

--4

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

--5

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--6

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

--7

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

--or

SELECT r.name, COUNT(s.name) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

-- GROUP BY Part II

/*
1. For each account, determine the average amount of 
each type of paper they purchased across their orders. 
Your result should have four columns - one for the 
account name and one for the average spent on each of 
the paper types.
*/

--1

SELECT a.name, AVG(o.standard_qty) avg_stand, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*
2. For each account, determine the average amount spent 
per order on each paper type. Your result should have 
four columns - one for the account name and one for 
the average amount spent on each paper type.
*/

--2

SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*
3. Determine the number of times a particular channel was 
used in the web_events table for each sales rep. Your 
final table should have three columns - the name of 
the sales rep, the channel, and the number of 
occurrences. Order your table with the highest number 
of occurrences first.
*/

--3

SELECT s.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;


/*

4. Determine the number of times a particular channel 
was used in the web_events table for each region. Your 
final table should have three columns - the region name
, the channel, and the number of occurrences. Order 
your table with the highest number of occurrences first.
*/



-- Solution Distinct
/*
Use DISTINCT to test if there are any accounts 
associated with more than one region.

The below two queries have the same number of resulting
 rows (351), so we know that every account is associated
  with only one region. If each account was associated 
  with more than one region, the first query should 
  have returned more rows than the second query.
*/

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

--and

SELECT DISTINCT id, name
FROM accounts;

/*

2. Have any sales reps worked on more than one account?

Actually all of the sales reps have worked on more than
 one account. The fewest number of accounts any sales 
 rep works on is 3. There are 50 sales reps, and they 
 all have more than one account. Using DISTINCT in the 
 second query assures that all of
 the sales reps are accounted for in the first query.

*/

-- CASE Statements
-- https://www.youtube.com/watch?v=BInXuTY_FzE


-- Code from the Video
-- Query 1:
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' END AS is_facebook
FROM web_events
ORDER BY occurred_at

-- Query 2:
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at
-- Query 3:
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' OR channel = 'direct' THEN 'yes' 
       ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at
-- Query 4:
SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 THEN '301 - 500'
            WHEN total > 100 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders
-- Query 5
SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <=300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders
/*
Derive

Take Data from existing Columns and Modify them.

Case statement handles If then
*/

-- Let's see how we can use the CASE statement to get around this error.

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;
-- Now, let's use a CASE statement. This way any time the standard_qty is zero, we will return 0, and otherwise, we will return the unit_price.

SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;


-- CASE & Aggregations
-- https://www.youtube.com/watch?v=asSXB6iD3z4

-- Code from the Video

--Query1

SELECT CASE WHEN total > 500 THEN 'OVer 500'
            ELSE '500 or under' END AS total_group,
            COUNT(*) AS order_count
FROM orders
GROUP BY 1

-- Query2

SELECT COUNT(1) AS orders_over_500_units
FROM orders
WHERE total > 500


-- Quiz:CASE

/*
1. Write a query to display for each order, the account ID, the total amount of the order, and the
level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller
than $3000.
*/

select a.id,o.total_amt_usd,
case when o.total_amt_usd>3000 then 'Large' else 'Small' end as level_of_order
from accounts a
join orders o
on a.id=o.account_id
Group by a.id,o.total_amt_usd

/*
2. Write a query to display the number of orders in each of three categories, based on the total number
 of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/

select case  when o.total>=2000 then 'At Least 2000' 
             when o.total Between 1000 and 2000 then 'Between 1000 and 2000'
             else 'Less than 1000' end as order_category,count(*)
from orders o
group by order_category

/*
3. We would like to understand 3 different levels of customers based on 
the amount associated with their purchases. The top-level includes anyone 
with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level.
 Order with the top spending customers listed first.

*/

select a.name,sum(o.total_amt_usd) total_spent, case  when sum(o.total_amt_usd)>200000 then 'greater than 200,000'
            when sum(o.total_amt_usd) between 200000 and 100000 then '200,000 and 100,000'
            else 'under 100,000' end as customer_levels
from accounts a
join orders o
on a.id=o.account_id
group by a.name
order by total_spent desc

-- Answer

SELECT a.name, SUM(total_amt_usd) total_spent, 
  CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
  WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
  ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

/*
4. We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017.
 Keep the same levels as in the previous question. Order with the top spending customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) total_spent, 
  CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
  WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
  ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at >'2015-12-31' and occurred_at <'2018-1-01' 
GROUP BY 1
ORDER BY 2 DESC;

/*
5. 
We would like to identify top-performing sales reps, which are sales reps
 associated with more than 200 orders. Create a table with the sales rep name, 
 the total number of orders, and a column with top or not depending on if they 
 have more than 200 orders. Place the top salespeople first in your final table.
*/

select s.name,count(o.id) orderCount,
case when count(o.id)>=200 then 'top'
else 'not' end as order_class
from sales_reps s
join accounts a
on a.sales_rep_id=s.id
join orders o
on o.account_id = a.id
group by s.name
order by 2 desc;

-- Answer

SELECT s.name, COUNT(o.id) orderCount,
CASE WHEN COUNT (o.id) >= 200 THEN 'Top'
ELSE 'Not' END AS repCategory
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC
/*
6.
The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top-performing sales reps, which are sales reps associated with more 
than 200 orders or more than 750000 in total sales. The middle group has any rep with 
more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, 
total sales across all orders, and a column with top, middle, or low depending on these criteria. 
Place the top salespeople based on the dollar amount of sales first in your final table. 
You might see a few upset salespeople by this criteria!
*/

SELECT s.name, COUNT(o.id) orderCount, SUM(total) totalSales,
CASE WHEN COUNT (o.id) >= 200 OR SUM(total) > 750000 THEN 'top'
WHEN COUNT (o.id) >= 150 OR SUM(total) > 500000 THEN 'middle'
ELSE 'low' END AS repCategory
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY repCategory DESC
-- LESSON 5
-- SQL Subqueries & Temporary Tables

/*

SQL Subqueries & Temporary Tables
In this lesson, you will learn about subqueries, a fundamental advanced SQL topic. This lesson will walk you through the appropriate applications of subqueries, the different types of subqueries, and review subquery syntax and examples.

*/

-- Query from video

SELECT channel,
       AVG(event_count) AS avg_event_count
FROM
(SELECT DATE_TRUNC('day',occurred_at) AS day,
        channel,
        count(*) as event_count
   FROM web_events
   GROUP BY 1,2
   ) sub
   GROUP BY 1
   ORDER BY 2 DESC

/*
-- QUIZ 1:

Find the number of events that occur for each day 
for each channel
*/

select date_trunc('day', occurred_at) as days,channel, count(channel) as event_num
from web_events
group by 1,2
order by 3 desc;



/* 
-- Quiz 2:
Now create a subquery that simply provides all of the 
data from your first query.
*/
select *
from
(
select date_trunc('day', occurred_at) as days,channel, count(channel) as event_num
from web_events
group by 1,2
order by 3 desc
)sub



/*
-- Quiz 3:
Now find the average number of events for each channel. Since you broke out by
day earlier, this is giving you an average per day.
*/

select channel,avg(event_num) average_events
from (
select date_trunc('day', occurred_at) as days,channel, count(channel) as event_num
from web_events
group by 1,2
order by 3 desc
  )sub
 group by 1
 order by 2 desc;


-- More on Subquery

/*

Use Date_Trunc to pull month level information about 
first order ever placed in the table
Use the result of the previous query to find the orders that took place in the
same month and year as the first, and then pull the average of each type of 
paper qty in this month.
*/

select avg(poster_qty)as avg_poster_qty,
   avg(standard_qty)as avg_stand_qty,
   avg(gloss_qty)as avg_gloss_qty,
   SUM(total_amt_usd)
from orders
where DATE_TRUNC('month',occurred_at)=
      (select DATE_TRUNC('month',min(occurred_at)) as min_month
      from orders
      )


-- Subquery Mania

/*
1. Provide the name of the sales_rep in 
each region with the largest amount of
total_amt_usd sales.
*/
select t3.rep_name,t3.reg_name,t3.largest_amt
from(select reg_name, max(largest_amt) largest_amt
   from(select s.name as rep_name,r.name as reg_name, sum(o.total_amt_usd) as largest_amt
      from sales_reps s
      join region r
      on s.region_id=r.id
      join accounts a
      on s.id=a.sales_rep_id
      join orders o 
      on a.id=o.account_id
      group by s.name, r.name
      order by 3 desc
      )t1
   group by reg_name
   order by 2 desc)t2
join(select s.name as rep_name,r.name as reg_name, sum(o.total_amt_usd) as largest_amt
      from sales_reps s
      join region r
      on s.region_id=r.id
      join accounts a
      on s.id=a.sales_rep_id
      join orders o 
      on a.id=o.account_id
      group by s.name, r.name
      order by 3 desc
      )t3
on t3.reg_name=t2.reg_name and t3.largest_amt=t2.largest_amt;


/*

2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/
select reg_name, max(sum_amt),total_orders
from(
select r.name as reg_name, sum(o.total_amt_usd) as sum_amt,count(*) total_orders
      from sales_reps s
      join region r
      on s.region_id=r.id
      join accounts a
      on s.id=a.sales_rep_id
      join orders o 
      on a.id=o.account_id
      group by r.name
      order by 2 desc
	)t1
group by 1,3
order by 2 desc
limit 1;


-- Or 

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);


/*
3. How many accounts had more total purchases
 than the account name which has bought the 
 most standard_qty paper throughout their 
 lifetime as a customer?
*/

select count(*)
from
(
select a.name
   FROM accounts a
   JOIN orders o
   ON o.account_id = a.id
   group by a.name
   Having sum(total) >
      (select total
         from
               (SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                  FROM accounts a
                  JOIN orders o
                  ON o.account_id = a.id
                  GROUP BY 1
                  ORDER BY 2 DESC
                  LIMIT 1) sub1)
)sub2;



/*
4. For the customer that spent the most 
(in total over their lifetime as a customer)
total_amt_usd, how many web_events did they
have for each channel?
*/

select  cust_name,channel, count(*)
from(select cust_name,cust_id
	from(select a.id cust_id,a.name cust_name,sum(o.total_amt_usd) as total_spent
		from accounts a
		join orders o
		on a.id=o.account_id
		group by 1,2
		order by 3 desc
		limit 1)t1)t2
join web_events w
on t2.cust_id=w.account_id
group by channel,cust_name
order by 3 desc;
-- or 

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC
                           LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;
/*
5. What is the lifetime average amount spent
in terms of total_amt_usd for the 
top 10 total spending accounts?
*/

select avg(sum_amt) avg_amt
from(select a.name,sum(o.total_amt_usd)as sum_amt
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	group by 1
	order by sum_amt desc
	limit 10) t1;
                           

/*
6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
*/


SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                   FROM orders o)) temp_table;





-- With
-- This helps in readability of our query logic

--e.g 

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

-- convert to WITH(CTE)
with events_day as(SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events_day
GROUP BY channel
ORDER BY 2 DESC;



/* 
For the above example, we don't need 
anymore than the one additional table, but 
imagine we needed to create a second table 
to pull from. We can create an additional 
table to pull from in the following way:
*/

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

-- Quiz With

/*
1. Provide the name of the sales_rep in each 
region with the largest amount of 
total_amt_usd sales.
*/




/*
Management of Relational and Non relational Databases
- Intro to DBMS: Relational and Non-Relational Databases
- Normalizing Data
- Data Definition language (DDL)
- Data MAnipulation Language (DML)
- Consistency with Constraints
- Performance with Indexes
- Intro to Non-Relational Databases
- Udiddit, A Social News Aggregator
*/
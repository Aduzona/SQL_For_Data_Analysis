-- SQL Joins
-- Why we want to Split Data into Separate Tables?

/*
using parch and posey database:
1. Orders and accounts are different types of objects and it will be
easier to organize if kept separate.
2. Multi-table structure allows querries to execute more quickly

-- 1.
Accounts table:
|id|name|website|
|--|----|-------|
|1001|Comapny1|www.webA.com|
|1021|Company2|www.webB.com| 

This account table stores different kinds of object.
Parch and porse probably want one account per company and they want it to be 
up-to-date with the latest information

ORDERS table:
|id|account_id|time|
|--|--|---|
|1|1001|time1|
|2|1001|time2|
|3|1021|time3|

orders are likely to stay the same once they are entered.
a given customer might have multiple orders and rather than change a past order,
parch and posey might add a new one.
because these objects Accounts and ORDERS operate differently, 
it makes sense to operate in different tables.


-- 2.
Speed at which databases can modify data.
if accounts and order table are together, the query will be slow,
also you update more frequently.

Database Normalization
When creating a database, it is really important to think about how data will be stored. This is known as normalization, and it is a huge part of most SQL classes. If you are in charge of setting up a new database, it is important to have a thorough understanding of database normalization.

There are essentially three ideas that are aimed at database normalization:

Are the tables storing logical groupings of the data?
Can I make changes in a single location, rather than in many tables for the same information?
Can I access and manipulate data quickly and efficiently?
This is discussed in detail [here](https://www.itprotoday.com/sql-server/sql-design-why-you-need-database-normalization).

However, most analysts are working with a database that was already set up with the necessary properties in place. As analysts of data, you don't really need to think too much about data normalization. You just need to be able to pull the data from the database, so you can start making insights. This will be our focus in this lesson.
*/

-- Introduction to JOINs
/*
This entire lesson will be focused on JOINs. The whole purpose of JOIN statements is to allow us to pull data from more than one table at a time.

Again - JOINs are useful for allowing us to pull data from multiple tables. This is both simple and powerful all at the same time.

With the addition of the JOIN statement to our toolkit, we will also be adding the ON statement.

We use ON clause to specify a JOIN condition which is a logical statement to combine the table in FROM and JOIN statements.

Parts of join:
1. INNER JOIN

*/
/*
As we've learned, the SELECT clause indicates which column(s) of data you'd like to see in the output (For Example, orders.* gives us all the columns in orders table in the output). The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. The ON clause specifies the column on which you'd like to merge the two tables together. Try running this query yourself below.
*/

Select orders.*
from orders
join accounts
on orders.account_id =accounts.id 
/*
What to Notice
We are able to pull data from two tables:

1. orders
2. accounts
Above, we are only pulling data from the orders table since in the SELECT statement we only reference columns from the orders table.

The ON statement holds the two columns that get linked across the two tables. This will be the focus in the next concepts.
*/


/*
Additional Information
If we wanted to only pull individual elements from either the orders or accounts table, we can do this by using the exact same information in the FROM and ON statements. However, in your SELECT statement, you will need to know how to specify tables and columns in the SELECT statement:

1. The table name is always before the period.
2. The column you want from that table is always after the period.
For example, if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns, we can do this with the following query:

*/

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
This query only pulls two columns, not all the information in these two tables. Alternatively, the below query pulls all the columns from both the accounts and orders table.
*/
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Joining tables allows you access to each of the tables in the SELECT statement through the table name, and the columns will always follow a . after the table name.

Now it's your turn.

Quiz Questions
1. Try pulling all the data from the accounts table, and all the data from the orders table.

2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/

-- 1.
select accounts.*, orders.*
from accounts
JOIN orders
ON accounts.id=orders.account_id;

-- 2. 
select orders.standard_qty,orders.gloss_qty,orders.poster_qty,
accounts.website,accounts.primary_poc
from orders
join accounts
ON orders.account_id = accounts.id;

-- ERD Reminder
-- Entity Relationship Diagrams
-- See ERD.pdf to answer these questions
-- primary_foreign_key.pdf
-- Join_revisited.pdf
-- Alias.pdf
select o.*,a.*
From orders o
join accounts a 
on o.account_id=a.id

-- another way
Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

-- Quiz: JOIN Questions Part I
-- Join_Question1 - Udacity.pdf
/*
Questions
1. Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

2. Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

*/

-- 1.
select a.primary_poc,we.occurred_at,we.channel,a.name
from web_events as we
join accounts as a
on we.account_id = a.id
where a.name='walmart';

-- 2.
select r.name as region_name, sr.name as sales_rep_name,a.name as account_name
from region as r
join sales_reps as sr
on sr.region_id=r.id
join accounts as a
on a.sales_rep_id=sr.id
Order by a.name;

-- 3.
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;


/*
It might be nice if SQL enforced JOINs to be PK = FK,
but if you want to join company name to the last 
name of another column, SQL will let you do it!

We can simply write our alias directly after the column name (in the SELECT) 
or table name (in the FROM or JOIN) by writing the alias directly following 
the column or table we would like to alias. This will allow you to create 
clear column names even if calculations are used to create the column, and you 
can be more efficient with your code by aliasing table names.
*/

/*
Motivation for Other Joins

Expert Tip
You have had a bit of an introduction to these one-to-one and one-to-many relationships when we introduced PKs and FKs. Notice, traditional databases do not allow for many-to-many relationships, as these break the schema down pretty quickly. A very good answer is provided [here](https://stackoverflow.com/questions/7339143/why-no-many-to-many-relationships).

The types of relationships that exist in a database matter less to analysts, but you do need to understand why you would perform different types of JOINs, and what data you are pulling from the database. These ideas will be expanded upon in the next concepts.


*/



-- LEFT and RIGHT JOINS

/*
 Inner Join: https://www.youtube.com/watch?v=CxuHtd1Daqk&ab_channel=Udacity
returns only row that occurs in both tables https://www.youtube.com/watch?v=CxuHtd1Daqk


Other Joins: https://www.youtube.com/watch?v=4edRxFmWUEw&ab_channel=Udacity 
Left Join
the left table + intersection between left and right table

Right Join

Full Outer Join

*

-- Other Join Notes.pdf


-- left_right_join.pdf
/*
see left_right_join_solution.pdf
Question 3:
That's right! Since this is a JOIN (INNER JOIN technically), we only get rows that show up in both tables. Therefore our resulting table will essentially look like the right table with the countryName pulled in as a column. Since 1, 2, 3, and 4 are countryids in both tables, this information will be pulled together. The countryids of 5 and 6 only show up in the Country table. Therefore, these will be dropped.

Question 4:
Thanks for completing that!
That's right! We have a column for each of the identified elements in our SELECT statement. We will have all of the same rows as in a JOIN statement, but we also will obtain the additional two rows in the Country table that are not in the State table for Sri Lanka and Brazil.

*/

-- JOINs and Filtering
select o.*.a.*
from orders o
left join accounts a 
on o.account_id=a.id 
where a.sales_rep_id= 321500

-- Change where to and , this becomes part of the on clause
-- This is like a where clause applied before the join is executed rather than after.
-- this will include empty cells.
select o.*.a.*
from orders o
left join accounts a 
on o.account_id=a.id 
and a.sales_rep_id= 321500

/*
A simple rule to remember this is that, when the database executes this query, it executes the join and everything in the ON clause first. Think of this as building the new result set. That result set is then filtered using the WHERE clause.

The fact that this example is a left join is important. Because inner joins only return the rows for which the two tables match, moving this filter to the ON clause of an inner join will produce the same result as keeping it in the WHERE clause.
*/

-- Join_and_Filtering_Questions.pdf
-- Join_and_Filtering_Answers.pdf.pdf




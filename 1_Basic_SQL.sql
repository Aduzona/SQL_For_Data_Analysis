/*
Can You Use LIMIT?
Try using LIMIT yourself below by writing a query that 
displays all the data in the occurred_at, account_id, and channel columns of the web_events table,
 and limits the output to only the first 15 rows.
*/

select occurred_at,account_id,channel
From web_events limit 15;

/* ORDER BY*/
/* Sort orders by date 
this orders in ascending order*/
select *
from orders
order by occurred_at
limit 5;

select *
from orders
order by occurred_at DESC
limit 5;


/*
Practice
Let's get some practice using ORDER BY:

1. Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.


2. Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.


3. Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.

*/

-- 1.
select id, occurred_at,total_amt_usd
from orders 
order by occurred_at
limit 10;

-- 2. 
select id, account_id, total_amt_usd
from orders
order by total_amt_usd DESC
limit 5;

-- 3.
select id, account_id, total_amt_usd
from orders
order by total_amt_usd 
limit 20;


-- ORDER BY PART II
/*
Order results by account, within each account, have the order
sorted from largest to smallest, so you can see what the largest 
order where for each account.

use order by over multiple columns to achieve this and the
sorting will happen in the order you specify the columns.

*/

select account_id,total_amt_usd
from orders
order by account_id,total_amt_usd DESC

/*
Questions
1. Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).

2. Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).

3. Compare the results of these two queries above. How are the results different when you switch the column you sort on first?

*/

-- 1.
select id,account_id,total_amt_usd
from orders
order by account_id,total_amt_usd desc;

--2.
select id,account_id,total_amt_usd
from orders
order by total_amt_usd desc,account_id;

-- 3.
/*
In query #1, all of the orders for each account ID are grouped together,
and then within each of those groupings, the orders appear from the greatest 
order amount to the least. In query #2, since you sorted by the total dollar amount first, 
the orders appear from greatest to least regardless of which account ID they were from. 
Then they are sorted by account ID next. (The secondary sorting by account ID is 
difficult to see here, since only if there were two orders with equal total dollar amounts 
would there need to be any sorting by account ID.)
*/

-- WHERE
-- Allows you to filter specific results based on specific criteria.

select *
from orders
where account_id= 4251
ORDER BY occurred_at
Limit 1000;

/*
Questions
Write a query that:

1. Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.

2. Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.

*/

-- 1.
select *
from orders
where gloss_amt_usd >= 1000
limit 5;

-- 2.
select *
from orders
where total_amt_usd < 500
limit 10;


-- WHERE with Non-Numeric Data
/*
If you're using an operator with values that are non-numeric,
you need to put the value in single quotes

Practice Question Using WHERE with Non-Numeric Data
1. Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
*/

-- 1.
select name, website, primary_poc
from accounts
where name='Exxon Mobil';

-- ARITHMETIC OPERATORS
/*
Derived Column: A New column that is a manipulation of 
the existing columns in your database
*/

-- e.g 
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;
-- AS keyword to name this new column "std_percent"


/*
Questions using Arithmetic Operations
Using the orders table:

1. Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.

2. Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. You will learn later in the course how to fully handle this issue. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.


Notice, the above operators combine information across columns for the same row. If you want to combine values of a particular column, across multiple rows, you will do this with aggregations. 
*/

-- 1.
select (standard_amt_usd/standard_qty) as unit_price,id,account_id
from  orders
limit 10;

-- 2.
select id,account_id ,(poster_amt_usd/total_amt_usd) *100 as poster_amt_percent
from orders
limit 10;

-- OR
SELECT id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;


--  Introduction to Logical Operators

/*

Introduction to Logical Operators
In the next concepts, you will be learning about Logical Operators. Logical Operators include:

1. LIKE
This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.

2. IN
This allows you to perform operations similar to using WHERE and =, but for more than one condition.

3. NOT
This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.

4. AND & BETWEEN
These allow you to combine operations where all combined conditions must be true.

5. OR
This allow you to combine operations where at least one of the combined conditions must be true.



*/


-- LIKE

/*
The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %. The % tells us that we might want any number of characters leading up to a particular set of characters or following a certain set of characters, as we saw with the google syntax above. Remember you will need to use single quotes for the text you pass to the LIKE operator, because of this lower and uppercase letters are not the same within the string. Searching for 'T' is not the same as searching for 't'. In other SQL environments (outside the classroom), you can use either single or double quotes.

Hopefully you are starting to get more comfortable with SQL, as we are starting to move toward operations that have more applications, but this also means we can't show you every use case. Hopefully, you can start to think about how you might use these types of applications to identify phone numbers from a certain region, or an individual where you can't quite remember the full name.
*/

-- e.g
select *
from web_events
where referrer_url Like '%google%'


/*
Questions using the LIKE operator
Use the accounts table to find

1. All the companies whose names start with 'C'.

2. All companies whose names contain the string 'one' somewhere in the name.

3. All companies whose names end with 's'.
*/

-- 1. 
select name 
from accounts
where name like 'C%';


-- 2.
select name 
from accounts
where name like '%one%';

-- 3. 
select name 
from accounts
where name like '%S';


-- IN

/*
The IN operator is useful for working with both numeric and text columns. This operator allows you to use an =, but for more than one item of that particular column. We can check one, two or many column values for which we want to pull data, but all within the same query. In the upcoming concepts, you will see the OR operator that would also allow us to perform these tasks, but the IN operator is a cleaner way to write these queries.
Expert Tip:

In most SQL environments, you can use single or double quotation marks - and you may NEED to use double quotation marks if you have an apostrophe within the text you are attempting to pull.

In our Udacity SQL workspaces, note you can include an apostrophe by putting two single quotes together. For example, Macy's in our workspace would be 'Macy''s'.
*/

-- e.g. checking  performance of some accounts
select *
from orders
where account_id IN (1001,1021)

/*
Questions using IN operator
1. Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.


2. Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.


*/

-- 1.
select name,primary_poc,sales_rep_id
from accounts
where name in ('Walmart','Target','Nordstrom')

-- 2. 
select *
from web_events
where channel in ('organic','adwords')

-- NOT
/*
The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE. By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria.
*/
-- considering promoting 2 of our top sales reps into management,
-- figure out how to divvy up all of their accounts amoung the other sales reps
-- seeing others apart from them
select sales_rep_id, name
from accounts
where sales_rep_id in Not (321500,321570)
order by sales_rep_id;

-- web traffic not google
select *
from web_events
where referrer_url Not like '%google%';


/*
Questions using the NOT operator
We can pull all of the rows that were excluded from the queries in the previous two concepts with our new operator.

1. Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.

2. Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.

Use the accounts table to find:

1. All the companies whose names do not start with 'C'.

2. All companies whose names do not contain the string 'one' somewhere in the name.

3. All companies whose names do not end with 's'.
*/

-- Not in
-- 1.
select name,primary_poc,sales_rep_id
from accounts
where name not in ('Walmart','Target','Nordstrom')

-- 2. 
select *
from web_events
where channel not in ('organic','adwords')


-- not like

-- 1. 
select name 
from accounts
where name not like 'C%';


-- 2.
select name 
from accounts
where name not like '%one%';

-- 3. 
select name 
from accounts
where name not like '%S';



-- AND and BETWEEN
/*

The AND operator is used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND, you will need to specify the column you are interested in looking at. You may link as many statements as you would like to consider at the same time. This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /). LIKE, IN, and NOT logic can also be linked together using the AND operator.

BETWEEN Operator
Sometimes we can make a cleaner statement using BETWEEN than we can using AND. Particularly this is true when we are using the same column for different parts of our AND statement. In the previous video, we probably should have used BETWEEN.

Instead of writing :

WHERE column >= 6 AND column <= 10
we can instead write, equivalently:

WHERE column BETWEEN 6 AND 10

Which of your customers purchased a while ago, decide if it is due for
another purchase

*/

select *
from orders
where occurred_at >= '2016-04-01' and occurred_at <= '2016-10-01'
order by occurred_at Desc;

/*
Questions using AND and BETWEEN operators
1. Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.

2. Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.

3. When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.

4. Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
*/


-- 1.
select *
from orders
where standard_qty>1000 and poster_qty=0 and gloss_qty=0;

-- 2.
select name
from accounts
where name not like 'C%' and name not like '%s';

-- 3.
select occurred_at,gloss_qty
from orders
where gloss_qty between 24 and 29;

/*
You should notice that there are a number of rows in the output of this query where the gloss_qty values are 24 or 29. So the answer to the question is that yes, the BETWEEN operator in SQL is inclusive; that is, the endpoint values are included. So the BETWEEN statement in this query is equivalent to having written "WHERE gloss_qty >= 24 AND gloss_qty <= 29."
*/

-- 4.

/*
You will notice that using BETWEEN is tricky for dates! While BETWEEN is generally inclusive of endpoints, it assumes the time is at 00:00:00 (i.e. midnight) for dates. This is the reason why we set the right-side endpoint of the period at '2017-01-01'.
*/
select *
from web_events
where channel in ('organic','adwords') and occurred_at >= '2016-01-01' and occurred_at <= '2016-12-31'
order by occurred_at DESC;

-- alternative 4.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;


--OR operator
/*
Similar to the AND operator, the OR operator can combine multiple statements. Each time you link a new statement with an OR, you will need to specify the column you are interested in looking at. You may link as many statements as you would like to consider at the same time. This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /), LIKE, IN, NOT, AND, and BETWEEN logic can all be linked together using the OR operator.

When combining multiple of these operations, we frequently might need to use parentheses to assure that logic we want to perform is being executed correctly. The query below shows an example of one of these situations.
*/
select account_id,occurred_at,standard_qty,gloss_qty,poster_qty
from orders
where (standard_qty =0 or gloss_qty=0 or poster_qty=0)
and occurred_at>= '2016-10-01';

/*
Questions using the OR operator
1. Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.


2. Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.


3. Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.

*/

-- 1.
select id
from orders
where gloss_qty>4000 or poster_qty>4000

-- 2.
select *
from orders
where standard_qty=0 and (gloss_qty>1000 or poster_qty>1000)

-- 3.
 
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
           AND primary_poc NOT LIKE '%eana%');


-- RECAP

/*
Commands
You have already learned a lot about writing code in SQL! Let's take a moment to recap all that we have covered before moving on:

Statement	How to Use It	Other Details
SELECT	SELECT Col1, Col2, ...	Provide the columns you want
FROM	FROM Table	Provide the table where the columns exist
LIMIT	LIMIT 10	Limits based number of rows returned
ORDER BY	ORDER BY Col	Orders table based on the column. Used with DESC.
WHERE	WHERE Col > 5	A conditional statement to filter your results
LIKE	WHERE Col LIKE '%me%'	Only pulls rows where column has 'me' within the text
IN	WHERE Col IN ('Y', 'N')	A filter for only rows with column of 'Y' or 'N'
NOT	WHERE Col NOT IN ('Y', 'N')	NOT is frequently used with LIKE and IN
AND	WHERE Col1 > 5 AND Col2 < 3	Filter rows where two or more conditions must be true
OR	WHERE Col1 > 5 OR Col2 < 3	Filter rows where at least one condition must be true
BETWEEN	WHERE Col BETWEEN 3 AND 5	Often easier syntax than using an AND
Other Tips
Though SQL is not case sensitive (it doesn't care if you write your statements as all uppercase or lowercase), we discussed some best practices. The order of the key words does matter! Using what you know so far, you will want to write your statements as:

SELECT col1, col2
FROM table1
WHERE col3  > 5 AND col4 LIKE '%os%'
ORDER BY col5
LIMIT 10;
Notice, you can retrieve different columns than those being used in the ORDER BY and WHERE statements. Assuming all of these column names existed in this way (col1, col2, col3, col4, col5) within a table called table1, this query would run just fine.

Looking Ahead
In the next lesson, you will be learning about JOINs. This is the real secret (well not really a secret) behind the success of SQL as a language. JOINs allow us to combine multiple tables together. All of the operations we learned here will still be important moving forward, but we will be able to answer much more complex questions by combining information from multiple tables! You have already mastered so much - potentially writing your first code ever, but it is about to get so much better!
*/









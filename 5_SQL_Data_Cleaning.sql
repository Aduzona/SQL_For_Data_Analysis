-- SQL Data Cleaning

/*

In this lesson, you will be learning a number of techniques to

1. Clean and re-structure messy data.
2. Convert columns to different data types.
3. Tricks for manipulating NULLs.
This will give you a robust toolkit to get from raw data to clean data that's useful for analysis.
*/

--LEFT and RIGHT
/*
Here we looked at three new functions:

1. LEFT
2. RIGHT
3. LENGTH

LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left). As you saw here, you can pull the first three digits of a phone number using LEFT(phone_number, 3).


RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right). As you saw here, you can pull the last eight digits of a phone number using RIGHT(phone_number, 8).


LENGTH provides the number of characters for each row of a specified column. Here, you saw that we could use this to get the length of each phone number as LENGTH(phone_number).
*/

-- LEFT & RIGHT Quiz
/*
1. LEFT & RIGHT Quizzes
In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
*/
select right(website,3) extensions, count(1)
from accounts
group by 1
order by 2 desc;

/*
2. There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
*/

select left(lower(name),1) caps, count(1)
from accounts
group by 1
order by 2 desc;

/*
3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
*/

select num_letter,count(1)
from (
SELECT name,CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 'num'
                       else 'letter'
                       end as num_letter
 from accounts) t1
 group by 1;

--or

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;


/*
4 
Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
*/

select vow_conso,count(1)
from (
SELECT name,CASE WHEN LEFT(lower(name), 1) IN ('a','e','i','o','u') 
                       THEN 'vowels'
                       else 'consonants'
                       end as vow_conso
 from accounts) t1
 group by 1;

 -- or

 SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                        THEN 1 ELSE 0 END AS vowels, 
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;


-- Position, STRPOS

/*
1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
*/

select primary_poc,
left(primary_poc,strpos(primary_poc,' ')-1)  first_name,
right(primary_poc,LENGTH(primary_poc)-strpos(primary_poc,' '))  last_name
from accounts;

/*
2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
*/
select name,
left(name,strpos(name,' ')-1)  first_name,
right(name,LENGTH(name)-strpos(name,' '))  last_name
from sales_reps;


-- CONCAT
/*


CONCAT(first_name,' ',last_name) as full_name,
or 
first_name ||' '||last_name as full_name_alt
*/

/*
1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

*/
select primary_poc,
left(primary_poc,strpos(primary_poc,' ')-1)  ||'.'||
right(primary_poc,LENGTH(primary_poc)-strpos(primary_poc,' ')) ||'@'||name||'.com' as email
from accounts;

/*
2. You may have noticed that in the previous 
solution some of the company names include 
spaces, which will certainly not work in an 
email address. See if you can create an email
address that will work by removing all of the
spaces in the account name, but otherwise your
solution should be just as in question 1.
*/
select primary_poc,
left(primary_poc,strpos(primary_poc,' ')-1)  ||'.'||
right(primary_poc,LENGTH(primary_poc)-strpos(primary_poc,' ')) ||'@'||Replace(name,' ','')||'.com' as email
from accounts;

--or

WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;
/*
3. We would also like to create an initial 
password, which they will change after their 
first log in. The first password will be the 
first letter of the primary_poc's first name 
(lowercase), then the last letter of their 
first name (lowercase), the first letter of 
their last name (lowercase), the last letter 
of their last name (lowercase), the number of
letters in their first name, the number of 
letters in their last name, and then the 
name of the company they are working with, 
all capitalized with no spaces.
*/

WITH t1 AS (
 SELECT LEFT(primary_poc,STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', Replace(name,' ',''), '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') as password
FROM t1;

-- or

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', Replace(name,' ',''), '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') as password
from (
    SELECT LEFT(primary_poc,STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts
)t1

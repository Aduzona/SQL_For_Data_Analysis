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

Find the number of events that occur for each day 
for each channel
*/

select date_trunc('day',occurred_at) as day,
channel,count(1) as number
from web_events
group by 1,2
order by 1;

-- QUIZ 1:

/* Now create a subquery that simply provides all of the 
data from your first query.
*/
select *
from
(
select date_trunc('day',occurred_at) as day,
channel,count(1) as number
from web_events
group by 1,2
order by 1;
)sub

-- Quiz 2:

/*
Now find the average number of events for each channel. Since you broke out by
day earlier, this is giving you an average per day.
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
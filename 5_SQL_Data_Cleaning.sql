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
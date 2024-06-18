# String Functions
/* String functions in SQL are a set of built-in functions that allow you to manipulate and operate on string
 (character) data. These functions provide various operations such as concatenation, substring extraction,
 pattern matching, and string manipulation. */
-- A) CHAR_LENGTH(str): This function returns the length of the given string str in characters.
SELECT CHAR_LENGTH('Database Management');

-- B) ASCII(str): This function returns the ASCII code value of the leftmost character in the string str.
SELECT ASCII('B');
SELECT ASCII('xyz');

-- C) CONCAT(str1, str2, ...): This function concatenates two or more string values together.
SELECT CONCAT('SQL', ' ', 'Functions');

-- D) INSTR(str, substr): This function returns the position of the first occurrence
--    of the substring substr in the string str.
SELECT INSTR('SQL Functions', 'F');
SELECT INSTR('SQL Functions', 'Z');

-- E) LCASE(str) or LOWER(str): These functions convert the given string str to lowercase.
SELECT LCASE('DATABASE');
SELECT LOWER('Structure'); 

-- F) UCASE(str) or UPPER(str): These functions convert the given string str to uppercase.
SELECT UCASE('database');
SELECT UPPER('structure');

-- G) SUBSTR(str, start, length): This function extracts a substring from the string str starting at the position
--    start and with a length of length characters.
SELECT SUBSTR('SQL Functions', 5, 8);
SELECT SUBSTR('Database Management', 1, 8);

-- H) LPAD(str, len, padstr): This function pads the string str on the left side with the padstr string
--    repeated as many times as necessary to make the total length equal to len.
SELECT LPAD('SQL', 7, '-');

-- I) RPAD(str, len, padstr): This function pads the string str on the right side with the padstr string
--    repeated as many times as necessary to make the total length equal to len.
SELECT RPAD('SQL', 7, '-');

-- J) TRIM(str), RTRIM(str), LTRIM(str): These functions remove leading and/or trailing spaces from the string str.
--    TRIM removes leading and trailing spaces, RTRIM removes trailing spaces, and LTRIM removes leading spaces.
SELECT TRIM('   SQL Functions   ');
SELECT RTRIM('   SQL Functions   ');
SELECT LTRIM('   SQL Functions   ');

# Date and Time Functions
/* Date and time functions in SQL are a set of built-in functions that allow you to manipulate and perform
 operations on date and time data types. These functions help you extract components from date and time values,
 perform calculations, and format date and time information. */

-- A) CURRENT_DATE(): This function returns the current date in the format 'YYYY-MM-DD'.
SELECT CURRENT_DATE() AS today;
-- Output: 2024-06-18 (if the current date is June 18, 2024)

-- B) DATEDIFF(date1, date2): This function returns the number of days between two date values. 
-- The result can be positive or negative, depending on whether date1 is greater or less than date2.
SELECT DATEDIFF('2024-07-01', '2024-06-18') AS day_difference;
-- Output: 13

-- C) DATE(expression): This function extracts the date part from a date or datetime expression.
SELECT DATE('2024-06-18 14:30:00') AS result;
-- Output: 2024-06-18

-- D) CURRENT_TIME(): This function returns the current time in the format 'HH:MM:SS'.
SELECT CURRENT_TIME() AS now;
-- Output: 14:45:00 (if the current time is 2:45:00 PM)

-- E) LAST_DAY(date): This function returns the last day of the month for a given date.
SELECT LAST_DAY('2024-06-18') AS last_day_of_june;
-- Output: 2024-06-30

-- F) SYSDATE(): This function returns the current date and time as a value in the format 'YYYY-MM-DD HH:MM:SS'.
SELECT SYSDATE() AS `Timestamp`;
-- Output: 2024-06-18 14:45:00 (if the current date and time is June 18, 2024, 2:45:00 PM)

-- G) ADDDATE(date, interval): This function adds a time interval to a date value and returns the new date.
SELECT ADDDATE('2024-06-18', INTERVAL 10 DAY) AS ten_days_later;
-- Output: 2024-06-28

# Numeric Functions
/* Numeric functions in SQL are a set of built-in functions that allow you to perform various mathematical
 operations and calculations on numeric data types, such as integers, floating-point numbers, and decimal values.
 These functions help you manipulate and analyze numerical data in your database tables. */
 
-- A) AVG(expression): This function returns the average value of the non-null values in a group.
--    It's commonly used with the GROUP BY clause.
SELECT AVG(quantity) AS avg_quantity
FROM orders;

-- B) COUNT(expression): This function returns the number of non-null values in a group.
--    It can be used with or without the GROUP BY clause.
SELECT COUNT(*) AS total_orders
FROM orders;

-- C) POW(base, exponent): This function returns the value of base raised to the power of exponent.
SELECT POW(3, 4) AS result;
-- Output: 81

-- D) MIN(expression): This function returns the minimum value in a group. It's often used with the GROUP BY clause.
SELECT MIN(price) AS min_price
FROM products;

-- E) MAX(expression): This function returns the maximum value in a group. It's often used with the GROUP BY clause.
SELECT MAX(quantity) AS max_quantity, category
FROM products
GROUP BY category;

-- F) ROUND(number, [decimals]): This function rounds a number to a specified number of decimal places. 
--    If decimals is omitted, it rounds to the nearest integer.
SELECT ROUND(7.256, 2) AS result; -- Output: 7.26
SELECT ROUND(7.256) AS result; -- Output: 7

-- G) SQRT(number): This function returns the square root of a non-negative number.
SELECT SQRT(49) AS result; -- Output: 7

-- H) FLOOR(number): This function returns the largest integer value that is less than or equal to the given number.
SELECT FLOOR(4.9) AS result; -- Output: 4
SELECT FLOOR(-4.9) AS result; -- Output: -5



```sql
-- Introduction to SQL Operators in MySQL with detailed examples and comments

-- =========================================
-- Arithmetic Operators
-- =========================================

-- Arithmetic operators perform mathematical operations on numeric data.
-- The common arithmetic operators are: +, -, *, /, and % (modulus).

-- Example: Addition (+)
SELECT 12 + 7 AS AdditionResult;       -- This will return 19

-- Example: Subtraction (-)
SELECT 25 - 9 AS SubtractionResult;    -- This will return 16

-- Example: Multiplication (*)
SELECT 8 * 9 AS MultiplicationResult;  -- This will return 72

-- Example: Division (/)
SELECT 45 / 9 AS DivisionResult;       -- This will return 5

-- Example: Modulus (%)
SELECT 29 % 6 AS ModulusResult;        -- This will return 5 (remainder of 29 divided by 6)

-- Using arithmetic operators with columns in a table
-- Recreate and populate the Students table for examples
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE,
    EnrollmentDate DATE,
    TuitionFees DECIMAL(12, 2),
    Scholarship DECIMAL(12, 2)
);

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, TuitionFees, Scholarship)
VALUES
(1, 'Navya', 'Ramani', '2000-01-01', '2020-08-15', 20000.00, 5000.00),
(2, 'Teja', 'Revuri', '1999-02-20', '2018-09-10', 18000.00, 4000.00),
(3, 'Nisha', 'Sri', '2001-05-15', '2019-07-22', 22000.00, 6000.00);

-- Example: Calculating total fees after scholarship (tuition fees - scholarship)
SELECT FirstName, LastName, TuitionFees, Scholarship, (TuitionFees - Scholarship) AS TotalFees
FROM Students;

-- Example: Calculating the difference between tuition fees and scholarship
SELECT FirstName, LastName, TuitionFees, Scholarship, (TuitionFees - Scholarship) AS FeesAfterScholarship
FROM Students;

-- =========================================
-- Comparison Operators
-- =========================================

-- Comparison operators compare two values and return a boolean result.
-- The common comparison operators are: =, <>, >, <, >=, <=, and BETWEEN.

-- Example: Equal to (=)
SELECT * FROM Students
WHERE TuitionFees = 20000.00;              -- This will return the row where TuitionFees is 20000.00

-- Example: Not equal to (<>)
SELECT * FROM Students
WHERE TuitionFees <> 20000.00;             -- This will return rows where TuitionFees is not 20000.00

-- Example: Greater than (>)
SELECT * FROM Students
WHERE TuitionFees > 18000.00;              -- This will return rows where TuitionFees is greater than 18000.00

-- Example: Less than (<)
SELECT * FROM Students
WHERE TuitionFees < 20000.00;              -- This will return rows where TuitionFees is less than 20000.00

-- Example: Greater than or equal to (>=)
SELECT * FROM Students
WHERE TuitionFees >= 18000.00;             -- This will return rows where TuitionFees is 18000.00 or more

-- Example: Less than or equal to (<=)
SELECT * FROM Students
WHERE TuitionFees <= 20000.00;             -- This will return rows where TuitionFees is 20000.00 or less

-- Example: BETWEEN
SELECT * FROM Students
WHERE TuitionFees BETWEEN 18000.00 AND 22000.00; -- This will return rows where TuitionFees is between 18000.00 and 22000.00

-- =========================================
-- Logical Operators
-- =========================================

-- Logical operators are used to combine multiple conditions in a WHERE clause.
-- The common logical operators are: AND, OR, and NOT.

-- Example: AND
SELECT * FROM Students
WHERE TuitionFees > 18000.00 AND Scholarship > 4000.00; -- This will return rows where both conditions are true

-- Example: OR
SELECT * FROM Students
WHERE TuitionFees > 20000.00 OR Scholarship > 5000.00;  -- This will return rows where either condition is true

-- Example: NOT
SELECT * FROM Students
WHERE NOT TuitionFees = 20000.00;                 -- This will return rows where TuitionFees is not 20000.00

-- =========================================
-- Other Operators
-- =========================================

-- Other useful operators include IN, LIKE, IS NULL, and IS NOT NULL.

-- Example: IN
SELECT * FROM Students
WHERE TuitionFees IN (20000.00, 22000.00);        -- This will return rows where TuitionFees is either 20000.00 or 22000.00

-- Example: LIKE
SELECT * FROM Students
WHERE FirstName LIKE 'N%';                   -- This will return rows where FirstName starts with 'N'

-- Example: IS NULL
-- Let's add a new column to illustrate NULL values
ALTER TABLE Students ADD Major VARCHAR(50);

-- Insert a new row with a NULL value for the Major column
INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, TuitionFees, Scholarship, Major)
VALUES (4, 'Kiran', 'Patel', '2002-03-14', '2021-06-01', 21000.00, 4500.00, NULL);

SELECT * FROM Students
WHERE Major IS NULL;                    -- This will return rows where Major is NULL

-- Example: IS NOT NULL
SELECT * FROM Students
WHERE Major IS NOT NULL;                -- This will return rows where Major is not NULL

-- =========================================
-- String Operators
-- =========================================

-- String operators are used to manipulate string data.
-- Common string operators/functions include CONCAT, LENGTH, SUBSTRING, and REPLACE.

-- Example: CONCAT
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Students;                               -- This will concatenate FirstName and LastName

-- Example: LENGTH
SELECT FirstName, LENGTH(FirstName) AS FirstNameLength
FROM Students;                               -- This will return the length of the FirstName

-- Example: SUBSTRING
SELECT FirstName, SUBSTRING(FirstName, 1, 2) AS FirstTwoLetters
FROM Students;                               -- This will return the first two letters of the FirstName

-- Example: REPLACE
SELECT FirstName, REPLACE(FirstName, 'a', 'A') AS ReplacedName
FROM Students;                               -- This will replace 'a' with 'A' in the FirstName

-- =========================================
-- Aggregate Functions
-- =========================================

-- Aggregate functions perform a calculation on a set of values and return a single value.
-- Common aggregate functions include COUNT, SUM, AVG, MIN, and MAX.

-- Example: COUNT
SELECT COUNT(*) AS StudentCount
FROM Students;                               -- This will return the total number of students

-- Example: SUM
SELECT SUM(TuitionFees) AS TotalTuition
FROM Students;                               -- This will return the sum of all tuition fees

-- Example: AVG
SELECT AVG(TuitionFees) AS AverageTuition
FROM Students;                               -- This will return the average tuition fees

-- Example: MIN
SELECT MIN(TuitionFees) AS MinimumTuition
FROM Students;                               -- This will return the minimum tuition fees

-- Example: MAX
SELECT MAX(TuitionFees) AS MaximumTuition
FROM Students;                               -- This will return the maximum tuition fees

-- Example: Using aggregate functions with GROUP BY
-- Adding another column to group data
ALTER TABLE Students ADD GradeLevel VARCHAR(50);

-- Updating the new column with values
UPDATE Students SET GradeLevel = 'Senior' WHERE StudentID IN (1, 4);
UPDATE Students SET GradeLevel = 'Junior' WHERE StudentID = 2;
UPDATE Students SET GradeLevel = 'Sophomore' WHERE StudentID = 3;

-- Grouping by GradeLevel and calculating aggregate values
SELECT GradeLevel, COUNT(*) AS NumberOfStudents, AVG(TuitionFees) AS AverageTuition
FROM Students
GROUP BY GradeLevel;                             -- This will group students by GradeLevel and calculate the count and average tuition fees for each group

-- =========================================
-- Conditional Operators
-- =========================================

-- Conditional operators return a value based on the evaluation of a condition.
-- Common conditional functions include IF, IFNULL, and CASE.

-- Example: IF
SELECT FirstName, LastName,
       IF(TuitionFees > 20000, 'High', 'Low') AS TuitionCategory
FROM Students;                               -- This will return 'High' if TuitionFees is greater than 20000, otherwise 'Low'

-- Example: IFNULL
SELECT FirstName, Major,
       IFNULL(Major, 'Undeclared') AS MajorStatus
FROM Students;                               -- This will replace NULL Major values with 'Undeclared'

-- Example: CASE
SELECT FirstName, LastName, TuitionFees,
       CASE
           WHEN TuitionFees > 22000 THEN 'A'
           WHEN TuitionFees BETWEEN 18000 AND 22000 THEN 'B'
           ELSE 'C'
       END AS TuitionGrade
FROM Students;                               -- This will return a grade based on the tuition fees range

-- =========================================
--

 Bitwise Operators
-- =========================================
-- Bitwise operators perform bit-level operations on numeric data.
-- The common bitwise operators are: &, |, ^, ~, <<, and >>.

-- Example: AND (&)
SELECT 6 & 3 AS BitwiseAndResult;             -- This will return 2 (binary: 0110 & 0011 = 0010)

-- Example: OR (|)
SELECT 6 | 3 AS BitwiseOrResult;              -- This will return 7 (binary: 0110 | 0011 = 0111)

-- Example: XOR (^)
SELECT 6 ^ 3 AS BitwiseXorResult;             -- This will return 5 (binary: 0110 ^ 0011 = 0101)

-- Example: NOT (~)
SELECT ~6 AS BitwiseNotResult;                -- This will return -7 (binary: ~0110 = 1001 in two's complement form)

-- Example: Shift Left (<<)
SELECT 6 << 1 AS ShiftLeftResult;             -- This will return 12 (binary: 0110 << 1 = 1100)

-- Example: Shift Right (>>)
SELECT 6 >> 1 AS ShiftRightResult;            -- This will return 3 (binary: 0110 >> 1 = 0011)
```

```sql
-- Introduction to SQL with detailed examples and comments

-- =========================================
-- Data Definition Language (DDL) Commands
-- =========================================

-- 1. CREATE
-- The CREATE command is used to create new database objects.
-- Example: Creating a new table called 'Students'.

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,       -- Unique identifier for each student
    FirstName VARCHAR(50),           -- First name of the student
    LastName VARCHAR(50),            -- Last name of the student
    BirthDate DATE,                  -- Birth date of the student
    EnrollmentDate DATE,             -- Enrollment date of the student
    GPA DECIMAL(3, 2)                -- GPA of the student with two decimal points
);

-- 2. ALTER
-- The ALTER command modifies the structure of an existing database object.
-- Example: Adding a new column called 'Email' to the 'Students' table.

ALTER TABLE Students
ADD Email VARCHAR(100);              -- Adding an Email column to store email addresses

-- Example: Modifying the 'GPA' column to increase its precision.

ALTER TABLE Students
MODIFY COLUMN GPA DECIMAL(4, 3);     -- Increasing the precision of the GPA column

-- 3. DROP
-- The DROP command deletes existing database objects.
-- Example: Dropping the 'Students' table.

DROP TABLE Students;                 -- This will delete the Students table and all its data

-- 4. TRUNCATE
-- The TRUNCATE command removes all rows from a table.
-- Example: Truncating the 'Students' table.

-- Recreate the table for further examples
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE,
    EnrollmentDate DATE,
    GPA DECIMAL(4, 3),
    Email VARCHAR(100)
);

-- Inserting some data for the TRUNCATE example
INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES
(1, 'Navya', 'Ramani', '2002-04-15', '2020-08-20', 3.75, 'navya.ramani@example.com'),
(2, 'Revuri', 'Teja', '2001-09-12', '2019-08-20', 3.60, 'revuri.teja@example.com');

-- Now, truncate the table
TRUNCATE TABLE Students;             -- This removes all rows from the Students table

-- =========================================
-- Data Manipulation Language (DML) Commands
-- =========================================

-- Recreate the table and insert some data again for DML examples
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE,
    EnrollmentDate DATE,
    GPA DECIMAL(4, 3),
    Email VARCHAR(100)
);

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES
(1, 'Navya', 'Ramani', '2002-04-15', '2020-08-20', 3.75, 'navya.ramani@example.com'),
(2, 'Revuri', 'Teja', '2001-09-12', '2019-08-20', 3.60, 'revuri.teja@example.com'),
(3, 'Nisha', 'Sri', '2003-02-05', '2021-08-20', 3.85, 'nisha.sri@example.com');

-- 1. SELECT
-- The SELECT command retrieves data from the database.
-- Example: Selecting all columns from the 'Students' table.

SELECT * FROM Students;              -- This will display all columns for all students

-- Example: Selecting specific columns from the 'Students' table.

SELECT FirstName, LastName, GPA FROM Students; -- Display only first name, last name, and GPA

-- Example: Using the WHERE clause to filter results.

SELECT FirstName, LastName FROM Students
WHERE GPA > 3.70;                    -- Display only students with a GPA greater than 3.70

-- Example: Using ORDER BY to sort results.

SELECT FirstName, LastName, GPA FROM Students
ORDER BY GPA DESC;                   -- Display students sorted by GPA in descending order

-- 2. INSERT
-- The INSERT command adds new rows to a table.
-- Example: Inserting a single row into the 'Students' table.

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES (4, 'Ananya', 'Verma', '2000-11-25', '2018-08-20', 3.95, 'ananya.verma@example.com');

-- Example: Inserting multiple rows into the 'Students' table.

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES
(5, 'Akhil', 'Patel', '2002-06-10', '2020-08-20', 3.80, 'akhil.patel@example.com'),
(6, 'Kiran', 'Mehta', '2001-12-14', '2019-08-20', 3.55, 'kiran.mehta@example.com');

-- 3. UPDATE
-- The UPDATE command modifies existing data within a table.
-- Example: Updating a single row in the 'Students' table.

UPDATE Students
SET GPA = 3.65
WHERE StudentID = 1;                -- Update the GPA of the student with StudentID 1

-- Example: Updating multiple rows in the 'Students' table.

UPDATE Students
SET GPA = GPA + 0.10
WHERE EnrollmentDate < '2021-01-01'; -- Increase the GPA by 0.10 for students enrolled before 2021

-- 4. DELETE
-- The DELETE command removes existing rows from a table.
-- Example: Deleting a specific row from the 'Students' table.

DELETE FROM Students
WHERE StudentID = 6;                -- Delete the student with StudentID 6

-- Example: Deleting multiple rows from the 'Students' table.

DELETE FROM Students
WHERE GPA < 3.60;                   -- Delete students with a GPA less than 3.60

-- Example: Deleting all rows from the 'Students' table (similar to TRUNCATE but logged).

DELETE FROM Students;               -- This removes all rows from the Students table

-- =========================================
-- Data Control Language (DCL) Commands
-- =========================================

-- 1. GRANT
-- The GRANT command gives specific privileges to users.
-- Example: Granting SELECT and INSERT privileges on the 'Students' table to a user.

GRANT SELECT, INSERT ON Students TO 'username';

-- 2. REVOKE
-- The REVOKE command removes specific privileges from users.
-- Example: Revoking INSERT privileges on the 'Students' table from a user.

REVOKE INSERT ON Students FROM 'username';

-- =========================================
-- Transaction Control Language (TCL) Commands
-- =========================================

-- 1. COMMIT
-- The COMMIT command saves all changes made in the current transaction.
-- Example: Using COMMIT after an INSERT command.

BEGIN TRANSACTION;                    -- Start a new transaction

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES (7, 'Rohit', 'Kumar', '2000-01-30', '2018-08-20', 3.90, 'rohit.kumar@example.com');

COMMIT;                               -- Commit the transaction

-- 2. ROLLBACK
-- The ROLLBACK command undoes all changes made in the current transaction.
-- Example: Using ROLLBACK after an INSERT command.

BEGIN TRANSACTION;                    -- Start a new transaction

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES (8, 'Aarti', 'Singh', '2003-10-15', '2021-08-20', 3.50, 'aarti.singh@example.com');

ROLLBACK;                             -- Roll back the transaction, the insert will not be saved

-- 3. SAVEPOINT
-- The SAVEPOINT command sets a point within a transaction to which you can later roll back.
-- Example: Using SAVEPOINT in a transaction.

BEGIN TRANSACTION;                    -- Start a new transaction

INSERT INTO Students (StudentID, FirstName, LastName, BirthDate, EnrollmentDate, GPA, Email)
VALUES (9, 'Navya', 'Sharma', '2002-03-25', '2020-08-20', 3.85, 'navya.sharma@example.com');

SAVEPOINT BeforeUpdate;               -- Set a savepoint before the update

UPDATE Students
SET GPA = 3.95
WHERE StudentID = 9;                -- Update the GPA of the newly inserted student

-- If needed, we can roll back to the savepoint
ROLLBACK TO BeforeUpdate;             -- Roll back to the savepoint, the update will be undone

COMMIT;
```

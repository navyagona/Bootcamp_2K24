use student_db;
-- DELIMITER COMMAND:
/*
1. Purpose: 
   - The DELIMITER command is used to change the standard delimiter (like a semicolon (;)) to a different character. 
2. Usage:
   - When defining stored procedures, functions, or other multi-statement constructs that contain semicolons within their body.
   - This allows you to specify a different character as the delimiter to avoid prematurely terminating the entire statement.
3. Syntax:
   - The syntax for the DELIMITER command is as follows:
     DELIMITER new_delimiter;
4. Example:
   - Changing the delimiter to //:
     DELIMITER //
     CREATE PROCEDURE procedure_name()
     BEGIN
         SQL statements
     END //
     DELIMITER ;

5. Resetting the delimiter:
   - After defining the stored procedure or function, you should reset the delimiter back to the standard semicolon (;) using:
     DELIMITER ;
*/

-- DETERMINISTIC: 
/*
DETERMINISTIC indicates that the function will always return the same result for the same input values.
If the function contains any non-deterministic elements (e.g., calls to functions that return different values each time they are called),
you should omit this keyword.
*/


-- PROCEDURES 
/*  A procedure is a set of SQL statements that can be saved and reused.
  ~ Procedures can have input parameters (IN) and output parameters (OUT).
  ~ Procedures do not return a value.
  ~ A procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
  ~ So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it. */
 
 
-- CREATE PROCEDURE
/* 
Procedures in SQL allow you to encapsulate a series of SQL statements into a reusable unit.
~ Syntax:
    DELIMITER //
        CREATE PROCEDURE procedure_name(parameter1 datatype, parameter2 datatype, ...)
        BEGIN
            Procedure logic goes here
        END //
    DELIMITER ;
*/ 

-- EXAMPLE:
-- Create a procedure to select all students
DELIMITER //
CREATE PROCEDURE select_all_students()
BEGIN
    SELECT * FROM students;
END //
DELIMITER ;

-- Execute the procedure
CALL select_all_students();

-- Drop the procedure
DROP PROCEDURE select_all_students;


-- EXECUTING PROCEDURES
/*
Once a procedure is created, you can execute it using the CALL statement followed by the procedure name and any required parameters.
~ Syntax:
-- CALL procedure_name(parameter1, parameter2, ...);
*/

-- DROPPING PROCEDURES
/*
If a procedure is no longer needed, it can be dropped using the DROP PROCEDURE statement.
~ Syntax: 
    DROP PROCEDURE procedure_name;
*/

-- FUNCTIONS
/*
A function is a reusable block of code that performs a specific task and can return a value.
Functions are similar to procedures, but procedures do not return values.
Functions can have input parameters (IN) but cannot have output parameters.
Input parameters allow you to pass data into the function, and the function can use that data to perform its task.
*/

-- FUNCTION CREATION
/*
To create a function, you need to define its name, input parameters (if any), and the data type of the value it returns.
The function logic (the code that performs the task) goes inside the BEGIN and END blocks.

Syntax:
CREATE FUNCTION function_name(parameter1 data_type, parameter2 data_type, ...)
RETURNS return_data_type
AS
BEGIN
    -- Function logic here
END;
*/

-- EXAMPLE:
-- Function to calculate total fees collected from completed payments
DELIMITER $$
CREATE FUNCTION get_total_fees()
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN
DECLARE total_fees DECIMAL(10,2); 
-- Declare a variable to store the total fees
-- Calculate the total fees by summing the 'amount' column from the 'payments' table
-- for all completed payments
SELECT SUM(p.amount) INTO total_fees
FROM payments p
INNER JOIN fees f ON p.fee_id = f.fee_id
WHERE p.status = 'completed';
RETURN total_fees; -- Returns the calculated total fees
END$$
DELIMITER ;
-- Restores the original delimiter


-- FUNCTION EXECUTION
/*
To execute (call) a function, you use the SELECT statement along with the function name and any required input parameters.
Syntax:
SELECT function_name(parameter1, parameter2, ...);
*/

-- EXAMPLE:
-- Calling the function
SELECT get_total_fees(); -- This will execute the function and return the total fees


-- DROPPING FUNCTION
/*
If you no longer need a function, you can drop (delete) it using the DROP FUNCTION statement.
Syntax:
DROP FUNCTION [IF EXISTS] function_name;
The IF EXISTS clause is optional and allows you to avoid an error if the function doesn't exist.
*/

-- EXAMPLE:
-- Dropping the function
DROP FUNCTION IF EXISTS get_total_fees;
-- This will remove the 'get_total_fees' function from the database


-- IN
/* 
This IN is a part of procedures
IN parameters in MySQL stored procedures allow you to pass values into the procedure.
These values are read-only within the procedure and cannot be modified
*/
 
/* 
~ Syntax for IN
CREATE PROCEDURE procedure_name(IN parameter_name data_type)
BEGIN
    -- Procedure logic using parameter_name
END;
*/

-- Creating procedure with IN
DELIMITER //
CREATE PROCEDURE get_student_details(IN student_id INT)
BEGIN
    SELECT * FROM students WHERE student_id = student_id;
END //

/*
EXPLANATION:
student_id is the IN parameter.
INT is the data type of the parameter.
*/

-- Calling Procedure
CALL get_student_details(1);
-- This will retrieve details for the student with ID 1.

/* 
EXPLANATION:
-> CREATE PROCEDURE get_student_details(IN student_id INT): This statement defines a procedure named get_student_details
with an IN parameter student_id of type INT.
-> BEGIN and END: These keywords mark the beginning and end of the procedure's body, respectively.
-> SELECT * FROM students WHERE student_id = student_id;: This is the SQL query inside the procedure that selects student details
based on the student_id parameter.
-> CALL get_student_details(1); This statement calls the procedure get_student_details with the argument 1, 
which is the student ID to retrieve details for.
*/



-- OUT
/* 
This OUT is a part of procedures
OUT parameters in MySQL stored procedures allow you to return values from a procedure. 
These values can be accessed by the calling program after the procedure execution. 
*/

/* 
~ Syntax
CREATE PROCEDURE procedure_name(OUT parameter_name data_type)
BEGIN
    -- Procedure logic using parameter_name
END;
*/

-- Create the procedure to get student count using OUT
DELIMITER //
CREATE PROCEDURE get_student_count(OUT student_count INT)
BEGIN
    SELECT COUNT(*) INTO student_count FROM students;
END //
/*
EXPLANATION:
student_count is the OUT parameter.
INT is the data type of the parameter.
*/

-- Calling the OUT Procedure
CALL get_student_count(@student_count);
SELECT @student_count as student_count;
/*
call -> Using @student_count to store the result
select -> Accessing the variable using @student_count
*/


/*
EXPLANATION:
-> CREATE PROCEDURE get_student_count(OUT student_count INT): This statement defines a procedure named get_student_count with an
OUT parameter student_count of type INT.
-> BEGIN and END: These keywords mark the beginning and end of the procedure's body, respectively.
-> SELECT COUNT(*) INTO student_count FROM students;: This is the SQL query inside the procedure that calculates the 
total number of students and stores it in the student_count variable.
-> CALL get_student_count(@student_count);: This statement calls the procedure get_student_count and 
passes the OUT parameter. The result is stored in the variable @student_count.
*/



-- CURSOR
/*
    1. Purpose:
        - Cursors in SQL are used to retrieve and process rows one by one from the result set of a query.
    2. Declaration:
        - Cursors are declared using the DECLARE CURSOR statement, specifying the SELECT query whose result set will be processed.
    3. Opening:
        - A cursor must be opened using the OPEN statement before fetching rows.
        - Opening a cursor positions the cursor before the first row.
    4. Fetching:
        - Rows from the result set are fetched one by one using the FETCH statement.
        - Each fetch operation advances the cursor to the next row in the result set.
    5. Closing:
        - After processing all rows, the cursor should be closed using the CLOSE statement.
        - Closing a cursor releases the resources associated with the result set and frees memory.
*/

/*
~ SYNTAX:

DECLARE cursor_name CURSOR FOR
SELECT column1, column2, ... 
FROM table_name 
WHERE condition;

OPEN cursor_name;

FETCH cursor_name INTO variable1, variable2, ...;

WHILE (condition) DO
    -- Process fetched row here
    -- Use fetched values stored in variables
    FETCH cursor_name INTO variable1, variable2, ...;
END WHILE;

CLOSE cursor_name;
*/

/* There exist two types of cursors based on their creation: user-defined and pre-defined */

/*
~ User-Defined Cursors:
    1. Purpose:
        - User-defined cursors are declared by the user to process rows retrieved from a query result set.
        - They are particularly useful when you need to perform custom operations on individual rows.

    2. Declaration:
        - User-defined cursors are declared using the DECLARE CURSOR statement, specifying the SELECT query whose result set will be processed.
        - This allows the user to define custom logic for

 fetching and processing rows.

    3. Usage:
        - User-defined cursors are explicitly opened, fetched, and closed by the user within stored procedures or functions.
        - They provide more control over row-by-row processing, enabling complex operations and transformations on fetched data.

    ~ Example:
        DECLARE my_cursor CURSOR FOR SELECT column1, column2 FROM my_table WHERE condition;
        OPEN my_cursor;
        FETCH my_cursor INTO var1, var2;
        WHILE (condition) DO
            -- Process fetched row
            FETCH my_cursor INTO var1, var2;
        END WHILE;
        CLOSE my_cursor;

~ Pre-Defined Cursors:
    1. Purpose:
        - Pre-defined cursors are system-defined cursors used by database management systems (DBMS) for specific purposes.
        - They are used internally by the DBMS to manage result sets, particularly for operations like triggers or statement-level operations.

    2. Declaration:
        - Pre-defined cursors are not explicitly declared by the user.
        - They are automatically created and managed by the DBMS based on the context of the operation.

    3. Usage:
        - Pre-defined cursors are used implicitly by the DBMS to handle result sets and row processing for specific system operations.
        - Users do not directly control the lifecycle of pre-defined cursors.
*/


-- EXAMPLE
DELIMITER //
CREATE PROCEDURE process_students()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE student_id INT;
    DECLARE student_name VARCHAR(255);
    DECLARE student_cursor CURSOR FOR SELECT id, name FROM students;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN student_cursor;
    
    fetch_loop: LOOP
        FETCH student_cursor INTO student_id, student_name;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        
        -- Process each student row here (e.g., print, update, etc.)
        -- Example: Just selecting the fetched row
        SELECT student_id, student_name;
        
    END LOOP;
    
    CLOSE student_cursor;
END //
DELIMITER ;

-- Execute the procedure
CALL process_students();


-- DECLARE done INT DEFAULT 0;: This statement declares a variable named done and initializes it with a value of 0.
-- DECLARE student_id INT;: This statement declares a variable named student_id of type INT.
-- DECLARE student_name VARCHAR(255);: This statement declares a variable named student_name of type VARCHAR(255).
-- DECLARE student_cursor CURSOR FOR SELECT id, name FROM students;: This statement declares a cursor named student_cursor
for the SELECT query that retrieves the id and name columns from the students table.
-- DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;: This statement declares a handler for the NOT FOUND condition.
When a row is not found during cursor fetching, the done variable is set to 1.
-- OPEN student_cursor;: This statement opens the student_cursor, allowing it to fetch rows from the result set.
-- fetch_loop: LOOP ... END LOOP;: This loop is used to fetch and process each row from the cursor.
The loop continues until the done variable is set to 1 (indicating no more rows).
-- FETCH student_cursor INTO student_id, student_name;: This statement fetches the next row from the cursor into
the student_id and student_name variables.
-- IF done THEN LEAVE fetch_loop; END IF;: This condition checks if the done variable is set to 1. 
If true, it exits the loop using the LEAVE statement.
-- SELECT student_id, student_name;: This statement processes each fetched row. In this example, it selects and 
displays the fetched student_id and student_name.
-- CLOSE student_cursor;: This statement closes the student_cursor, releasing the resources associated with it.


-- TRIGGERS
/* Triggers are a set of actions performed automatically when a specified event occurs in a database table.
   Triggers are used to maintain data integrity, enforce business rules, and perform complex actions based on 
   data modifications (INSERT, UPDATE, DELETE) */

-- BEFORE and AFTER Triggers:
/*
BEFORE and AFTER triggers specify the timing of trigger execution relative to the triggering event.
~ BEFORE Trigger:
    -> A BEFORE trigger executes before the triggering event (INSERT, UPDATE, DELETE) is applied to the table.
    -> This allows you to validate or modify the data before it is written to the table.
    -> It is useful for enforcing data integrity rules or logging changes before they occur.

~ AFTER Trigger:
    -> An AFTER trigger executes after the triggering event (INSERT, UPDATE, DELETE) has been applied to the table.
    -> This allows you to perform actions based on the final state of the data after the event.
    -> It is useful for tasks like auditing, logging, or updating related tables.

~ Syntax:
    CREATE TRIGGER trigger_name
    BEFORE | AFTER INSERT | UPDATE | DELETE
    ON table_name
    FOR EACH ROW
    BEGIN
        -- Trigger logic here
    END;
*/

-- Example of BEFORE and AFTER Triggers
-- Creating a table to store audit logs
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(50),
    affected_table VARCHAR(50),
    affected_id INT,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BEFORE Trigger Example
DELIMITER //
CREATE TRIGGER before_student_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    -- Example: Logging the insert action
    INSERT INTO audit_logs (action_type, affected_table, affected_id, new_value)
    VALUES ('INSERT', 'students', NEW.student_id, NEW.name);
END //
DELIMITER ;

-- AFTER Trigger Example
DELIMITER //
CREATE TRIGGER after_student_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    -- Example: Logging the update action
    INSERT INTO audit_logs (action_type, affected_table, affected_id, old_value, new_value)
    VALUES ('UPDATE', 'students', NEW.student_id, OLD.name, NEW.name);
END //
DELIMITER ;

-- Explanation:
-- CREATE TRIGGER before_student_insert BEFORE INSERT ON students FOR EACH ROW BEGIN ... END;: This defines a BEFORE trigger named 
before_student_insert that executes before an INSERT operation on the students table.
-- Inside the trigger, an INSERT statement logs the insert action into the audit_logs table, capturing the action type,
affected table, affected ID, and new value.
-- CREATE TRIGGER after_student_update AFTER UPDATE ON students FOR EACH ROW BEGIN ... END;: This defines an AFTER trigger named 
after_student_update that executes after an UPDATE operation on the students table.
-- Inside the trigger, an INSERT statement logs the update action into the audit_logs table, capturing the action type, affected table,
affected ID, old value, and new value.


-- VIEW 
/* A view is a virtual table based on the result-set of an SQL statement. 
~ Purpose:
    -> Simplifies complex queries by encapsulating them in a view.
    -> Provides a way to present data differently from the way it is stored.
    -> Helps in implementing security by restricting access to specific columns or rows.

~ Syntax:
    CREATE VIEW view_name AS
    SELECT column1, column2, ...
    FROM table_name
    WHERE condition;

~ Example:
    CREATE VIEW student_view AS
    SELECT student_id, name, age
    FROM students
    WHERE age >= 18;

~ Usage:
    SELECT * FROM student_view; -- To use the view in a SELECT statement
*/

-- Create a view to display all student names and their courses
CREATE VIEW student_courses_view AS
SELECT s.name AS student_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Select from the view
SELECT * FROM student_courses_view;

-- Explanation:
-- CREATE VIEW student_courses_view AS SELECT s.name AS student_name, c.course_name FROM students s JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;: This creates a view named student_courses_view that joins the students, enrollments, and courses tables.
-- The view selects the student names and their corresponding course names.


-- INDEX 
/* An index in SQL is a database object that improves the speed of data retrieval operations on a table.
   An index is a structure that allows the database to find and retrieve specific rows much faster than it could without the index.
*/

-- CREATE INDEX
/*
~ Syntax:
    CREATE INDEX index_name
    ON table_name (column_name1, column_name2, ...);

~ Example:
    CREATE INDEX idx_student_name
    ON students (name);

This creates an index named idx_student_name on the name column of the students table.
The index improves the performance of queries that search for students by name.
*/

-- Create an index on the student_id column in the enrollments table
CREATE INDEX idx_enrollment_student_id
ON enrollments (student_id);


-- DROP INDEX
/* If an index is no longer needed, it can be dropped using the DROP INDEX statement.
~ Syntax:
    DROP INDEX index_name
    ON table_name;

~ Example:
    DROP INDEX idx_student_name
    ON students;
*/

-- Drop the index on the student_id column in the enrollments table
DROP INDEX idx_enrollment_student_id
ON enrollments;

-- Explanation:
-- CREATE INDEX idx_enrollment_student_id ON enrollments (student_id);: This creates an index named idx_enrollment_student_id on the 
student_id column of the enrollments table. The index improves the performance of queries that search for enrollments by student ID.
-- DROP INDEX idx_enrollment_student_id ON enrollments;: This drops the

 index named idx_enrollment_student_id from the enrollments table,
removing the associated indexing structure.

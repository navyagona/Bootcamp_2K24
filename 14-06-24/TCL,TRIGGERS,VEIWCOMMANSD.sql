-- Create database
create database students;

use students;

-- Students - sid, sname, age, major
create table students
(
    sid int(3) primary key,
    sname varchar(50) not null,
    age int(3),
    major varchar(50)
);

-- Courses - cid, cname, credits
create table courses
(
    cid int(3) primary key,
    cname varchar(50) not null,
    credits int(2)
);

-- Enrollment - eid, sid, cid, semester
create table enrollment
(
    eid int(3) primary key,
    sid int(3),
    cid int(3),
    semester varchar(10),
    foreign key(sid) references students(sid),
    foreign key(cid) references courses(cid)
);

-- Grades - gid, eid, grade
create table grades
(
    gid int(3) primary key,
    eid int(3),
    grade varchar(2),
    foreign key(eid) references enrollment(eid)
);

-- Inserting values into students table
insert into students values(1, 'Alice', 20, 'Computer Science');
insert into students values(2, 'Bob', 22, 'Mechanical Engineering');
insert into students values(3, 'Charlie', 21, 'Electrical Engineering');
insert into students values(4, 'David', 23, 'Mathematics');
insert into students values(5, 'Eve', 20, 'Physics');

-- Inserting values into courses table
insert into courses values(101, 'Data Structures', 3);
insert into courses values(102, 'Algorithms', 3);
insert into courses values(103, 'Thermodynamics', 4);
insert into courses values(104, 'Electromagnetics', 3);
insert into courses values(105, 'Linear Algebra', 3);

-- Inserting values into enrollment table
insert into enrollment values(1001, 1, 101, 'Fall 2023');
insert into enrollment values(1002, 1, 102, 'Fall 2023');
insert into enrollment values(1003, 2, 103, 'Fall 2023');
insert into enrollment values(1004, 3, 104, 'Fall 2023');
insert into enrollment values(1005, 4, 105, 'Fall 2023');
insert into enrollment values(1006, 5, 101, 'Fall 2023');

-- Inserting values into grades table
insert into grades values(1, 1001, 'A');
insert into grades values(2, 1002, 'B');
insert into grades values(3, 1003, 'A');
insert into grades values(4, 1004, 'C');
insert into grades values(5, 1005, 'B');
insert into grades values(6, 1006, 'A');
-- TCL (Transaction Control Language) Commands
/*
TCL commands are used to manage transactions, maintain ACID properties, and control the flow of data modifications.
TCL commands ensure the consistency and durability of data in a database.
For example, if an operation fails during a transaction, the transaction is rolled back.
When a transaction is committed, its changes are permanent, even if the system fails or restarts.
TCL commands also ensure that all operations within a transaction are executed as a single unit.
*/

-- COMMIT
/*
Commit: Saves a transaction to the database
Example: Saving changes made by insert, update, or delete operations.
*/
COMMIT;

-- ROLLBACK
/*
Rollback: Undoes a transaction or change that hasn't been saved to the database
Example: Undoing changes if an error occurs during a transaction.
*/
ROLLBACK;

-- SAVEPOINT
/*
Savepoint: Temporarily saves a transaction for later rollback 
Example: Creating a savepoint within a transaction.
*/
SAVEPOINT a;
-- Here it will store the current state as savepoint 'a'
-- After this, you can roll back to the savepoint 'a'
ROLLBACK TO a;

-- Any operation performed on a table using DML (Data Manipulation Language)
-- Insert, delete, update are all transaction operations.

-- In MySQL, auto-commit is enabled by default, so it automatically commits each transaction.
-- To use TCL commands in MySQL, you must start a transaction using the START TRANSACTION command.
START TRANSACTION;

-- Example of a transaction:
-- Inserting a new student record
INSERT INTO students (sid, sname, age, major) VALUES (6, 'Nisha', 21, 'Biology');

-- Creating a savepoint
SAVEPOINT b;

-- Updating a student record
UPDATE students SET age = 22 WHERE sid = 6;

-- Rolling back to savepoint b (undoes the update but keeps the insert)
ROLLBACK TO b;

-- Committing the transaction (saves the insert permanently)
COMMIT;

-- Example of rolling back a transaction completely:
START TRANSACTION;

-- Deleting a student record
DELETE FROM students WHERE sid = 6;

-- Rolling back the transaction (undoes the delete)
ROLLBACK;

-- Triggers 

-- Trigger is a statement that a system executes automatically when there is any modification to the database
-- Triggers are used to specify certain integrity constraints and referential constraints that cannot be specified using the constraint mechanism of SQL

-- Triggers are 6 types 
/*
1)after insert -- activated after data is inserted into the table.
2)after update -- activated after data in the table is modified. 
3)after delete -- activated after data is deleted/removed from the table. 
4)before insert -- activated before data is inserted into the table. 
5)before update -- activated before data in the table is modified.
6)before delete --  activated before data is deleted/removed from the table. 
*/
-- Delimiters are necessary when creating stored procedures or triggers
-- Delimiters are used in MySQL to avoid conflicts with semicolons within SQL statements

-- "SQL Trigger for Logging Student Insertions"
-- after insert
DELIMITER //
CREATE TRIGGER students_after_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
  INSERT INTO student_log (sid, sname, age, major, inserted_at)
  VALUES (NEW.sid, NEW.sname, NEW.age, NEW.major, NOW());
END //
DELIMITER ;

-- Create an SQL trigger to automatically update the number of enrolled students in a course after each new enrollment is inserted into the 'enrollment' table
DELIMITER //
CREATE TRIGGER enrollment_after_insert
AFTER INSERT ON enrollment
FOR EACH ROW
BEGIN
  UPDATE courses
  SET enrolled_students = enrolled_students + 1
  WHERE cid = NEW.cid;
END //
DELIMITER ;

-- after update 

-- SQL trigger to log changes made to student information whenever an update occurs in the 'students' table
DELIMITER //
CREATE TRIGGER students_after_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
  IF OLD.sid <> NEW.sid OR OLD.sname <> NEW.sname OR OLD.age <> NEW.age OR OLD.major <> NEW.major THEN
    INSERT INTO student_log (sid, sname, age, major, updated_at)
    VALUES (OLD.sid, OLD.sname, OLD.age, OLD.major, NOW());
  END IF;
END //
DELIMITER ;

-- after delete 

-- SQL trigger to prevent the deletion of a student from the 'students' table if there are existing enrollments referencing that student in the 'enrollment' table
DELIMITER //
CREATE TRIGGER students_after_delete
AFTER DELETE ON students
FOR EACH ROW
BEGIN
  -- Log information about deleted student (optional)
  -- INSERT INTO student_log (sid, sname, age, major, deleted_at)
  -- VALUES (OLD.sid, OLD.sname, OLD.age, OLD.major, NOW());

  -- Check if there are existing enrollments referencing the deleted student
  DECLARE has_enrollments INT DEFAULT 0;

  SELECT COUNT(*) INTO has_enrollments
  FROM enrollment
  WHERE sid = OLD.sid;

  IF has_enrollments > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete student with existing enrollments. Update or delete enrollments first.';
  END IF;
END //
DELIMITER ;

-- before insert

-- Trigger for setting default major to 'Undeclared' if not provided
DELIMITER //
CREATE TRIGGER set_default_major
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
  IF NEW.major IS NULL THEN
    SET NEW.major = 'Undeclared';
  END IF;
END //
DELIMITER ;

--Filter Student Data by Role
DELIMITER //
CREATE TRIGGER filter_students_by_role
BEFORE SELECT ON students
FOR EACH ROW
BEGIN
  DECLARE user_role VARCHAR(50);
  DECLARE user_id INT;

  -- Get user role and user ID from session variables or another source
  SET user_role = 'student';  -- Replace with logic to get actual role
  SET user_id = 1;  -- Replace with logic to get actual user ID

  IF user_role = 'admin' THEN
    SET FOUND = 1;  -- Allow admin to see all student records
  ELSEIF user_role = 'student' AND NEW.sid = user_id THEN
    SET FOUND = 1;  -- Allow students to see only their own records
  ELSE
    SET FOUND = 0;  -- Block other roles from seeing data
  END IF;
END //
DELIMITER ;

--Filter Grades Data by Role
DELIMITER //
CREATE TRIGGER filter_grades_by_role
BEFORE SELECT ON grades
FOR EACH ROW
BEGIN
  DECLARE user_role VARCHAR(50);
  DECLARE user_id INT;

  -- Get user role and user ID from session variables or another source
  SET user_role = 'student';  -- Replace with logic to get actual role
  SET user_id = 3;  -- Replace with logic to get actual user ID

  IF user_role = 'admin' THEN
    SET FOUND = 1;  -- Allow admin to see all grade records
  ELSEIF user_role = 'student' AND EXISTS (
    SELECT 1
    FROM enrollment
    WHERE eid = NEW.eid AND sid = user_id
  ) THEN
    SET FOUND = 1;  -- Allow students to see only their own grades
  ELSE
    SET FOUND = 0;  -- Block other roles from seeing data
  END IF;
END //
DELIMITER ;



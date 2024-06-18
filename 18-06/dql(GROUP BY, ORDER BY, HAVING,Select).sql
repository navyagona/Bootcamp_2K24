```sql
-- Create database
CREATE DATABASE IF NOT EXISTS students_db;
USE students_db;

-- Create Students table
CREATE TABLE IF NOT EXISTS students (
    sid INT AUTO_INCREMENT PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    age INT,
    address VARCHAR(100)
);

-- Create Courses table
CREATE TABLE IF NOT EXISTS courses (
    cid INT AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Create Enrollments table
CREATE TABLE IF NOT EXISTS enrollments (
    eid INT AUTO_INCREMENT PRIMARY KEY,
    sid INT,
    cid INT,
    grade CHAR(1),
    FOREIGN KEY (sid) REFERENCES students(sid) ON DELETE CASCADE,
    FOREIGN KEY (cid) REFERENCES courses(cid) ON DELETE CASCADE
);

-- Insert sample data into Students table
INSERT INTO students (sname, age, address) VALUES
('Navya', 20, 'Bangalore'),
('Manohar', 22, 'Mumbai'),
('Teja', 21, 'Vizag'),
('Arjun', 23, 'Bangalore'),
('Sriya', 22, 'Mumbai');

-- Insert sample data into Courses table
INSERT INTO courses (cname, location) VALUES
('Mathematics', 'Room 101'),
('Physics', 'Room 102'),
('Chemistry', 'Room 103'),
('Biology', 'Room 104'),
('Computer Science', 'Room 105');

-- Insert sample data into Enrollments table
INSERT INTO enrollments (sid, cid, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(2, 3, 'A'),
(3, 4, 'B'),
(4, 5, 'C'),
(5, 1, 'B'),
(5, 2, 'A');

-- GROUP BY
-- In SQL, the GROUP BY clause is used to group rows that have the same values into summary rows.
USE students_db;

-- A) GROUP BY using HAVING
SELECT sname, COUNT(*) AS Number
FROM students
GROUP BY sname
HAVING Number >= 1;

-- B) GROUP BY using CONCAT
-- Group Concat is used in MySQL to get concatenated values of expressions with more than one result per column.
SELECT location, GROUP_CONCAT(DISTINCT cname) AS course_names
FROM courses
GROUP BY location;

-- C) GROUP BY can also be used while using aggregate function like COUNT, MAX, MIN, AVG, SUM, etc

-- ORDER BY
-- Used for ordering rows in a specific way
-- A) BASIC
-- ORDER BY x
-- x can be any datatype

-- B) ASCENDING
SELECT sid, sname, age
FROM students
ORDER BY age ASC;

-- C) DESCENDING
SELECT cid, cname, location
FROM courses
ORDER BY location DESC;

-- HAVING BY
/* The HAVING clause in SQL is used in conjunction with the GROUP BY clause to filter groups
   based on a specified condition. It is applied to the summarized or aggregated rows after the 
   grouping has been done. The HAVING clause works similarly to the WHERE clause, but it operates
   on groups instead of individual rows. */
-- EXAMPLES
-- A) Find the students with an age less than 22.
SELECT sid, sname, age
FROM students
GROUP BY sid, sname, age
HAVING age < 22;

-- B) Find the locations where the total number of students enrolled is greater than 1.
SELECT location, COUNT(*) AS total_students
FROM courses c
JOIN enrollments e ON c.cid = e.cid
GROUP BY location
HAVING COUNT(*) > 1;

-- -----------------------------------------------QUESTIONS-----------------------------------------------------------
/*
GROUP BY:
1) Write a query to find the total number of students enrolled in each course.
2) Write a query to find the number of students in each age range (e.g., 18-20, 21-23, 24+).
3) Write a query to find the average grade of students grouped by the course location.

ORDER BY:
1) Write a query to retrieve all courses ordered by their name in ascending order.
2) Write a query to retrieve all students ordered by their age in descending order.
3) Write a query to retrieve all enrollments ordered by the grade in ascending order and then by student name in descending order.

HAVING:
1) Write a query to find the locations where the total number of students enrolled is greater than 2.
2) Write a query to find the students who have enrolled in courses with a total of more than 1 enrollment.
3) Write a query to find the courses that have enrollments with grade 'A' and are located in 'Room 101'.
*/

-- -----------------------------------------------------------ANSWERS----------------------------------------------
-- GROUP BY:
-- 1)
SELECT c.cname, COUNT(e.sid) AS total_students
FROM courses c
JOIN enrollments e ON c.cid = e.cid
GROUP BY c.cname;

-- 2)
SELECT CASE 
    WHEN age BETWEEN 18 AND 20 THEN '18-20' 
    WHEN age BETWEEN 21 AND 23 THEN '21-23' 
    ELSE '24+' 
    END AS age_range, COUNT(*) AS student_count
FROM students
GROUP BY age_range;

-- 3)
SELECT c.location, AVG(CASE e.grade WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2 ELSE 0 END) AS avg_grade
FROM courses c
JOIN enrollments e ON c.cid = e.cid
GROUP BY c.location;

-- ORDER BY
-- 1)
SELECT * 
FROM courses 
ORDER BY cname ASC;

-- 2)
SELECT * 
FROM students 
ORDER BY age DESC;

-- 3)
SELECT e.eid, s.sname, e.grade
FROM enrollments e
JOIN students s ON e.sid = s.sid
ORDER BY e.grade ASC, s.sname DESC;

-- HAVING
-- 1)
SELECT c.location, COUNT(e.sid) AS total_students
FROM courses c
JOIN enrollments e ON c.cid = e.cid
GROUP BY c.location
HAVING COUNT(e.sid) > 2;

-- 2)
SELECT s.sid, s.sname, COUNT(e.cid) AS total_enrollments
FROM students s
JOIN enrollments e ON s.sid = e.sid
GROUP BY s.sid, s.sname
HAVING COUNT(e.cid) > 1;

-- 3)
SELECT c.cid, c.cname, c.location
FROM courses c
JOIN enrollments e ON c.cid = e.cid
WHERE c.location = 'Room 101'
GROUP BY c.cid, c.cname, c.location
HAVING SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) > 0;




-- DQL COMMANDS
-- 1) DQL stands for Data Query Language.

-- SELECT
-- Used to retrieve rows selected from one or more tables.
-- SELECT can be used in many ways

-- A) SELECT With DISTINCT Clause
-- The DISTINCT Clause after SELECT eliminates duplicate rows from the result set.
SELECT DISTINCT location FROM courses;

-- B) SELECT all columns(*)
SELECT * FROM students;

-- C) SELECT by column name
SELECT sname FROM students;

-- D) SELECT with LIKE(%)
-- Basically helps in searching using some syllables of the name

-- a) "a" anywhere
SELECT * FROM students WHERE sname LIKE "%a%";

-- b) Begins With "A"
SELECT * FROM students WHERE sname LIKE "A%";

-- c) Ends With "ya"
SELECT * FROM students WHERE sname LIKE "%ya";

-- E) SELECT with CASE or IF
-- a) CASE
SELECT sid,
       sname,
       CASE WHEN age >= 21 THEN 'Adult' ELSE 'Minor' END AS 'Category'
FROM students;

-- b) IF
SELECT sid,
       sname,
       IF(age >= 21, 'Adult', 'Minor') AS 'Category'
FROM students;

-- F) SELECT with a LIMIT Clause
SELECT * 
FROM students
ORDER BY sid
LIMIT 2;

-- G) SELECT with WHERE
SELECT * FROM students WHERE sname = "Teja";

-- ------------------------------------------QUESTIONS-------------------------------------------------------------
/*
1) Write a query to retrieve the distinct locations of courses from the courses table.
2) Write a query to retrieve the student ID, student name, and the length of their address
   as address_length from the students table.
3) Write a query to retrieve the enrollment ID, student name, course name, and the concatenated
   string 'Enrollment for [course name] by [student name]' as enrollment_description from the enrollments, students,
   and courses tables.
4) Write a query to retrieve the course ID, course name, location, and a new column location_type that categorizes
   the courses based on their location (e.g., 'Room 101' as 'Type A', 'Room 102' as 'Type B', and 'Room 103' as 'Type C').
5) Write a query to retrieve the student ID, student name, and the total grade points for each student.
   The total grade points should be retrieved from a subquery that calculates the sum of grade points for each
   student, assuming 'A' is 4, 'B' is 3, 'C' is 2, and 'D' is 1.
*/

-- --------------------------------------------ANSWERS-----------------------------------------------------------
-- 1)
SELECT DISTINCT location 
FROM courses;

-- 2)
SELECT sid, sname, LENGTH(address) AS address_length
FROM students;

-- 3)
SELECT e.eid, s.sname, c.cname, CONCAT('Enrollment for ', c.cname, ' by ', s.sname) AS enrollment_description
FROM enrollments e
JOIN students s ON e.sid = s.sid
JOIN courses c ON e.cid = c.cid;

-- 4)
SELECT cid, cname, location,
       CASE
           WHEN location = 'Room 101' THEN 'Type A'
           WHEN location = 'Room 102' THEN 'Type B'
           WHEN location = 'Room 103' THEN 'Type C'
           ELSE 'Other'
       END AS location_type
FROM courses;

-- 5)
SELECT s.sid, s.sname, (
    SELECT SUM(
               CASE e.grade
                   WHEN 'A' THEN 4
                   WHEN 'B' THEN 3
                   WHEN 'C' THEN 2
                   WHEN 'D' THEN 1
                   ELSE 0
               END)
    FROM enrollments e
    WHERE e.sid = s.sid
) AS total_grade_points
FROM students s;
```

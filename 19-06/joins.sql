CREATE DATABASE school_management;

USE school_management;

-- Creating table Students - sid, sname, age, gender, address
CREATE TABLE students (
    sid INT(3) PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    age INT(3),
    gender VARCHAR(10),
    address VARCHAR(100)
);

-- Creating table Courses - cid, cname, credits
CREATE TABLE courses (
    cid INT(3) PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    credits INT(3) NOT NULL
);

-- Creating table Enrollments - eid, sid, cid, enrollment_date
CREATE TABLE enrollments (
    eid INT(3) PRIMARY KEY,
    sid INT(3),
    cid INT(3),
    enrollment_date DATE,
    FOREIGN KEY(sid) REFERENCES students(sid),
    FOREIGN KEY(cid) REFERENCES courses(cid)
);

-- Creating table Grades - gid, eid, grade
CREATE TABLE grades (
    gid INT(3) PRIMARY KEY,
    eid INT(3),
    grade VARCHAR(2),
    FOREIGN KEY(eid) REFERENCES enrollments(eid)
);

-- Inserting values into students table
INSERT INTO students VALUES (101, 'Navya', 20, 'Female', 'Delhi');
INSERT INTO students VALUES (102, 'Arjun', 22, 'Male', 'Phagwara');
INSERT INTO students VALUES (103, 'Priya', 21, 'Female', 'Ludhiana');
INSERT INTO students VALUES (104, 'Kavya', 23, 'Female', 'Jalandhar');
INSERT INTO students VALUES (105, 'Rohit', 24, 'Male', 'Phagwara');

-- Inserting values into courses table
INSERT INTO courses VALUES (201, 'Mathematics', 4);
INSERT INTO courses VALUES (202, 'Physics', 3);
INSERT INTO courses VALUES (203, 'Chemistry', 3);
INSERT INTO courses VALUES (204, 'Biology', 4);

-- Inserting values into enrollments table
INSERT INTO enrollments VALUES (301, 101, 201, '2024-06-10');
INSERT INTO enrollments VALUES (302, 102, 202, '2024-06-11');
INSERT INTO enrollments VALUES (303, 103, 203, '2024-06-12');
INSERT INTO enrollments VALUES (304, 104, 204, '2024-06-13');

-- Inserting values into grades table
INSERT INTO grades VALUES (401, 301, 'A');
INSERT INTO grades VALUES (402, 302, 'B');
INSERT INTO grades VALUES (403, 303, 'A');
INSERT INTO grades VALUES (404, 304, 'C');

-- Displaying details of students table
SELECT * FROM students;

-- Displaying details of courses table
SELECT * FROM courses;

-- Displaying details of enrollments table
SELECT * FROM enrollments;

-- Displaying details of grades table
SELECT * FROM grades;

-- 1. Inner Join -> Matching values from both tables should be present
-- For example: For getting the name of students who are enrolled in courses, we need to inner join students and enrollments table
SELECT students.sid, sname, enrollments.eid FROM enrollments
INNER JOIN students ON enrollments.sid = students.sid;

-- Example 2: Getting the name of the students and the courses they are enrolled in
SELECT students.sid, sname, courses.cid, cname, eid FROM enrollments
INNER JOIN courses ON enrollments.cid = courses.cid
INNER JOIN students ON enrollments.sid = students.sid;

-- 2. Left Outer Join -> All the rows from the left table should be present and matching rows from the right table are present
-- Example: Getting the student id, student name, and enrollment details
SELECT students.sid, sname, eid, enrollment_date FROM students
LEFT JOIN enrollments ON enrollments.sid = students.sid;

-- 3. Right Join -> All the rows from the right table should be present and only matching rows from the left table are present 
-- Example: Displaying enrollment details and grades
SELECT * FROM grades 
RIGHT JOIN enrollments ON enrollments.eid = grades.eid;

-- 4. Full Join -> All the rows from both the table should be present 
-- Note: MySQL does not support full join we need to perform "UNION" operation between the results obtained from left and right join
-- Example: Displaying the details of all the enrollments and students
SELECT enrollments.eid, students.sid, sname, enrollment_date FROM enrollments
LEFT JOIN students ON enrollments.sid = students.sid
UNION
SELECT enrollments.eid, students.sid, sname, enrollment_date FROM enrollments
RIGHT JOIN students ON enrollments.sid = students.sid;

-- 5. Self Join -> It is a regular join, but the table is joined by itself
-- Example: Displaying the students who have the same address
SELECT s1.sname AS Student1, s2.sname AS Student2, s1.address FROM students s1
INNER JOIN students s2 ON s1.address = s2.address AND s1.sid != s2.sid;

-- 6. Cross Join -> It is used to view all the possible combinations of the rows of one table with all the rows from second table
-- Example: Displaying all the details of students and enrollments
SELECT students.sid, sname, enrollments.eid, enrollment_date FROM students
CROSS JOIN enrollments ON students.sid = enrollments.sid;


-- Create database
CREATE DATABASE students;
USE students;

-- Students table - sid, sname, age, address
CREATE TABLE students
(
    sid INT PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    age INT,
    address VARCHAR(100)
);

-- Courses table - cid, cname, duration, fee
CREATE TABLE courses
(
    cid INT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    duration INT,
    fee INT
);

-- Enrollments table - eid, sid, cid, grade
CREATE TABLE enrollments
(
    eid INT PRIMARY KEY,
    sid INT,
    cid INT,
    grade CHAR(1),
    FOREIGN KEY (sid) REFERENCES students(sid),
    FOREIGN KEY (cid) REFERENCES courses(cid)
);

-- Payments table - pay_id, eid, amount, mode, status, timestamp
CREATE TABLE payments
(
    pay_id INT PRIMARY KEY,
    eid INT,
    amount INT NOT NULL,
    mode VARCHAR(30) CHECK (mode IN ('upi', 'credit', 'debit')),
    status VARCHAR(30),
    timestamp TIMESTAMP,
    FOREIGN KEY (eid) REFERENCES enrollments(eid)
);

-- Insert sample data into students table
INSERT INTO students VALUES (1, 'NAVYA', 20, '123 Maple St');
INSERT INTO students VALUES (2, 'TEJA', 22, '456 Oak St');
INSERT INTO students VALUES (3, 'YUKTHA', 19, '789 Pine St');
INSERT INTO students VALUES (4, 'SRIYA', 21, '321 Cedar St');
INSERT INTO students VALUES (5, 'AYAN', 20, '654 Birch St');

-- Insert sample data into courses table
INSERT INTO courses VALUES (1, 'Mathematics', 6, 3000);
INSERT INTO courses VALUES (2, 'Physics', 6, 3500);
INSERT INTO courses VALUES (3, 'Chemistry', 6, 3200);
INSERT INTO courses VALUES (4, 'Biology', 6, 2800);
INSERT INTO courses VALUES (5, 'Computer Science', 6, 4000);

-- Insert sample data into enrollments table
INSERT INTO enrollments VALUES (1, 1, 1, 'A');
INSERT INTO enrollments VALUES (2, 2, 2, 'B');
INSERT INTO enrollments VALUES (3, 3, 3, 'C');
INSERT INTO enrollments VALUES (4, 4, 4, 'B');
INSERT INTO enrollments VALUES (5, 5, 5, 'A');

-- Insert sample data into payments table
INSERT INTO payments VALUES (1, 1, 3000, 'upi', 'completed', '2024-05-01 08:00:00');
INSERT INTO payments VALUES (2, 2, 3500, 'credit', 'completed', '2024-05-01 08:10:00');
INSERT INTO payments VALUES (3, 3, 3200, 'debit', 'in process', '2024-05-01 08:15:00');
INSERT INTO payments VALUES (4, 4, 2800, 'upi', 'completed', '2024-05-01 08:20:00');
INSERT INTO payments VALUES (5, 5, 4000, 'credit', 'completed', '2024-05-01 08:25:00');

--Subqueries
--Single-Row Subqueries:
#Example 1: Find the student who made the payment with the highest amount
SELECT sname 
FROM students 
WHERE sid = (SELECT sid 
             FROM enrollments 
             WHERE eid = (SELECT eid 
                          FROM payments 
                          ORDER BY amount DESC 
                          LIMIT 1));
#Example 2: Find the course with the highest fee
SELECT cname 
FROM courses 
WHERE fee = (SELECT MAX(fee) 
             FROM courses);

--Multiple-Row Subqueries:
#Example 1: Find all students who are enrolled in any course
SELECT sname
FROM students
WHERE sid IN (SELECT sid 
              FROM enrollments);
#Example 2: Find all students who are enrolled in courses with a fee greater than 3000.
SELECT sname
FROM students
WHERE sid IN (SELECT sid 
              FROM enrollments 
              WHERE cid IN (SELECT cid 
                            FROM courses 
                            WHERE fee > 3000));

--Correlated Subqueries:

#Example 1: Courses with fees higher than the average fee of courses in the same duration.
SELECT cname, fee
FROM courses c1
WHERE fee > (SELECT AVG(fee) 
             FROM courses c2 
             WHERE c2.duration = c1.duration);

#Example 2: Students with grades higher than the average grade in their respective courses.
SELECT sname
FROM students s
WHERE EXISTS (SELECT 1 
              FROM enrollments e 
              WHERE e.sid = s.sid 
              GROUP BY e.cid 
              HAVING AVG(CASE WHEN e.grade = 'A' THEN 4 
                              WHEN e.grade = 'B' THEN 3 
                              WHEN e.grade = 'C' THEN 2 
                              WHEN e.grade = 'D' THEN 1 
                              ELSE 0 END) > (SELECT AVG(CASE WHEN grade = 'A' THEN 4 
                                                             WHEN grade = 'B' THEN 3 
                                                             WHEN grade = 'C' THEN 2 
                                                             WHEN grade = 'D' THEN 1 
                                                             ELSE 0 END) 
                                             FROM enrollments 
                                             WHERE cid = e.cid));

--Joins
#Example 1: Inner join with subquery: Retrieve the students and their corresponding enrollments where the fee is greater than 3000.
SELECT s.sname, e.eid, e.grade
FROM students s
INNER JOIN (
    SELECT *
    FROM enrollments
) e ON s.sid = e.sid
WHERE e.cid IN (SELECT cid 
                FROM courses 
                WHERE fee > 3000);

#Example 2: Left join with aggregate functions: Retrieve all students and their total payment amounts, even if there are no payments.
SELECT s.sname, COALESCE(SUM(p.amount), 0) AS total_payments
FROM students s
LEFT JOIN enrollments e ON s.sid = e.sid
LEFT JOIN payments p ON e.eid = p.eid
GROUP BY s.sname;

#Example 3: Right join with date and time functions: Retrieve all enrollments and their corresponding payment statuses and timestamps, even if there is no payment record.
SELECT e.eid, e.grade, p.status, p.timestamp
FROM enrollments e
RIGHT JOIN payments p ON e.eid = p.eid;

--Analytics Functions
#Example 1: RANK: Display rank of courses based on fee using RANK() function
SELECT cid, cname, fee, RANK() OVER (ORDER BY fee DESC) AS fee_rank
FROM courses;

#Example 2: DENSE_RANK: Display dense rank of courses based on fee using DENSE_RANK() function.
SELECT cid, cname, fee, DENSE_RANK() OVER (ORDER BY fee DESC) AS dense_fee_rank
FROM courses;

#Example 3: ROW_NUMBER: Assign a unique row number to each student based on their age.
SELECT ROW_NUMBER() OVER (ORDER BY age DESC) AS row_num, sid, sname, age, address
FROM students;

#Example 4: CUME_DIST: Find cumulative distribution of fees for courses.
SELECT cid, cname, fee, CUME_DIST() OVER (ORDER BY fee) AS cumulative_distribution
FROM courses;

#Example 5: LAG: Find the previous fee of the courses in the list, ordered by fee.
SELECT cname, fee, LAG(fee) OVER (ORDER BY fee) AS previous_fee
FROM courses;

#Example 6: LEAD: Find the next fee of the courses in the list, ordered by fee.
SELECT cname, fee, LEAD(fee) OVER (ORDER BY fee) AS next_fee
FROM courses;

--Questions:
--Subqueries:
#Find the name of the student who made the payment with the highest total amount.
SELECT sname 
FROM students 
WHERE sid = (SELECT sid 
             FROM enrollments 
             WHERE eid = (SELECT eid 
                          FROM payments 
                          ORDER BY amount DESC 
                          LIMIT 1));

#Retrieve the names of all students who are enrolled in courses located in the same city as the student named "Bob".
SELECT sname
FROM students
WHERE sid IN (
    SELECT DISTINCT sid
    FROM enrollments
    WHERE cid IN (
        SELECT cid
        FROM courses
        WHERE location = (
            SELECT address
            FROM students
            WHERE sname = 'Bob'
        )
    )
);
#Retrieve the names of all students who have enrolled in courses that have a fee higher than the average fee of courses enrolled by each student.
SELECT sname
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM enrollments e
    JOIN courses c ON e.cid = c.cid
    WHERE e.sid = s.sid
    AND c.fee > (
        SELECT AVG(fee)
        FROM enrollments e2
        JOIN courses c2 ON e2.cid = c2.cid
        WHERE e2.sid = s.sid
    )
);

--Joins:
#Retrieve the details of students along with their corresponding courses using INNER JOIN.
SELECT s.sname, c.cname, e.grade
FROM students s
INNER JOIN enrollments e ON s.sid = e.sid
INNER JOIN courses c ON e.cid = c.cid;

#Retrieve the details of all students including those who have not enrolled in any course using LEFT JOIN.
SELECT s.sname, c.cname, e.grade
FROM students s
LEFT JOIN enrollments e ON s.sid = e.sid
LEFT JOIN courses c ON e.cid = c.cid;

#Retrieve the details of all courses along with the students enrolled in them, including courses without any enrollments using RIGHT JOIN.
SELECT c.cname, s.sname, e.grade
FROM courses c
RIGHT JOIN enrollments e ON c.cid = e.cid
RIGHT JOIN students s ON e.sid = s.sid;

--Advanced Functions:
#Rank the students based on their total payment amount using RANK() function.
SELECT s.sname, SUM(p.amount) AS total_payments, RANK() OVER (ORDER BY SUM(p.amount) DESC) AS payment_rank
FROM students s
JOIN enrollments e ON s.sid = e.sid
JOIN payments p ON e.eid = p.eid
GROUP BY s.sname;

#Assign a unique row number to each course based on their fee using ROW_NUMBER() function.
SELECT cname, fee, ROW_NUMBER() OVER (ORDER BY fee DESC) AS row_num
FROM courses;

#Calculate the cumulative distribution of course fees using CUME_DIST() function.
SELECT cname, fee, CUME_DIST() OVER (ORDER BY fee) AS cumulative_distribution
FROM courses;

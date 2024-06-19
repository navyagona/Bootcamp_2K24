--Anomalies:
--Anomalies represent undesirable conditions in a relational database that result in inconsistencies, potentially leading to data manipulation.

--Insertion Anomalies:
--Insertion anomalies arise when it is not possible to insert valid data due to restrictions imposed by the table's structure.

--Deletion Anomalies:
--Deletion anomalies occur when deleting a record unintentionally removes unrelated data from the database.

--Update Anomalies:
--Update anomalies happen when modifying a value in one record necessitates changes in other records to maintain data consistency, which can introduce errors.

-- Create Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200)
);

-- Create Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    credits INT
);

-- Create Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert Example Data into Students Table
INSERT INTO Students (student_id, student_name, date_of_birth, email, address)
VALUES
    (1, 'Navya', '2005-05-15', 'navya@gmail.com', 'ludiana'),
    (2, 'divya', '2006-08-22', 'revuri@gmail.com', 'phagwara');

-- Insert Example Data into Courses Table
INSERT INTO Courses (course_id, course_name, department, credits)
VALUES
    (101, 'Introduction to Computer Science', 'Computer Science', 3),
    (102, 'Database Management', 'Computer Science', 4);

-- Insert Example Data into Enrollments Table
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES
    (1001, 1, 101, '2023-01-10'),
    (1002, 2, 102, '2023-01-15');

-- Query to Demonstrate Insertion Anomaly
-- Trying to enroll a student in a non-existent course
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (1003, 1, 103, '2023-01-20');
-- This would fail because course_id 103 does not exist in the Courses table.

-- Query to Demonstrate Deletion Anomaly
-- Deleting a student without considering their enrollments
DELETE FROM Students WHERE student_id = 2;
-- This could leave enrollments in the Enrollments table orphaned.

-- Query to Demonstrate Update Anomaly
-- Updating the department name in Courses without cascading updates
UPDATE Courses SET department = 'IT' WHERE course_id = 101;
-- This might lead to inconsistencies if other courses under 'Computer Science' are not updated accordingly.

-- Query to Display Students Information
SELECT student_id, student_name, date_of_birth, email, address
FROM Students;

-- Query using Foreign Key Relationship
-- Retrieve enrollment details for a specific student (e.g., student_id 1)
SELECT e.enrollment_id, s.student_name, c.course_name
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE s.student_id = 1;

--1NF - First Normal Form: Ensures atomic values and eliminates repeating groups.
--2NF - Second Normal Form: Non-key attributes depend on the entire primary key.
--3NF - Third Normal Form: Eliminates transitive dependencies.

--1NF 
-- before 1NF
/*student_id	student_name	date_of_birth      	email	              phone_numbers
1	               NAVYA	  2005-05-15	   navya@gmail.com	     123-456-7890, 987-654-3210
2	               DIVYA    2006-08-22	   revuri@gmail.com      555-123-4567
*/
--after 1NF
/*student_id	student_name	date_of_birth	 email	             phone_number
1	            Navya	         2005-05-15	   navya@gmail.com	   123-456-7890
1	            Navya	         2005-05-15	   navya@gmail.com	   987-654-3210
2	            Divya	         2006-08-22	   revuri@gmail.com	   555-123-4567
/*

--2NF
--before 2NF
/*student_id	student_name	date_of_birth	   email	           course_name	                   course_department	credits
1	            Navya	         2005-05-15	   navya@gmail.com  Introduction to Computer science   Computer Science	       3
2            	Divya	         2006-08-22	   revuri@gmail.com    Database Management             	Computer Science	     4
/*
--after 2NF
/*student_id	student_name	date_of_birth	   email	           course_name	                   course_department	credits
1	            Navya	         2005-05-15	   navya@gmail.com  Introduction to Computer science   Computer Science	       3
2            	Divya	         2006-08-22	   revuri@gmail.com    Database Management             	Computer Science	     4
/*

--3NF
--before 3NF
/*student_id	student_name	date_of_birth    	email	             course_name	                    department	         department_location	credits
1	            Navya	          2000-01-15	  navya@gmail.com	    Introduction to Computer Science	Computer Science	     Building A	           3
2	            Divya	           1999-05-22	  divya@gmail.com	    Database Management              	Computer Science	     Building B	           4
/*
--after 3NF
/*student_id	student_name	date_of_birth	  email	            course_name	                    department_name	      department_location
1	              Navya	       2005-01-15	  navya@gmail.com 	Introduction to Computer Science	Computer Science	       Building A
2	              Divya	       2006-05-22 	divya@gmail.com 	Database Management             	Computer Science	       Building B
/*

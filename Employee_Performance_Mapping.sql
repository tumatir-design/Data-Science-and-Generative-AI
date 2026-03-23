CREATE DATABASE employee;

use employee;

SELECT * FROM employee.data_science_team;
SELECT * FROM employee.emp_record_table;
SELECT * FROM employee.proj_table;

-- query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT 
from the employee record table, 
and make a list of employees and details of their department. 

-- query to list only those employees who have someone reporting to them. 
SELECT 
    e.EMP_ID AS 'Manager_ID',
    COUNT(e.EMP_ID) AS 'NumberofReportees' --show the number of reporters 
    emp_record_table e
        JOIN
    emp_record_table m ON e.EMP_ID = m.MANAGER_ID
GROUP BY 1
ORDER BY 1;

--in order to Identify Maximum Salary
SELECT MAX(SALARY) AS Max_Salary 
FROM emp_record_table;

-- in order to find Employee Performance Mapping
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING 
FROM emp_record_table 
ORDER BY DEPT, EMP_RATING DESC;

-- in order to do Bonus Calculation (Extra Expense Report)

SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
       (0.05 * SALARY * EMP_RATING) AS BONUS_AMOUNT
FROM emp_record_table;

-- in order to do Role & Experience Validation
SELECT EMP_ID, FIRST_NAME, ROLE, EXP 
FROM emp_record_table 
WHERE (ROLE LIKE '%SENIOR%' AND EXP < 5) 
   OR (ROLE LIKE '%MANAGER%' AND EXP < 8);

-- in order to do Project Participation Review
SELECT e.EMP_ID, e.FIRST_NAME, p.PROJ_NAME, p.STATUS
FROM emp_record_table e
JOIN Proj_table p ON e.PROJ_ID = p.PROJECT_ID;

--CREATE DATABASE scienceqtech;
USE scienceqtech;

--Find the Maximum Salary
SELECT MAX(SALARY) AS Max_Salary FROM emp_record_table;
***result *** 16500

-- Calculate Employee Bonuses
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
(SALARY * 0.05) AS BONUS
FROM emp_record_table
WHERE EMP_RATING > 4

*** result ***
E001	Arthur	Black	16500	5	825.00
E052	Dianna	Wilson	5500	5	275.00
E083	Patrick	Voltz	9500	5	475.00
E204	Karene	Nowak	7500	5	375.00

--Employee Performance Mapping
SELECT DEPT, AVG(EMP_RATING) AS Avg_Rating 
FROM emp_record_table 
GROUP BY DEPT;

** result **
ALL	5.0000
FINANCE	3.3333
AUTOMOTIVE	3.0000
HEALTHCARE	3.2500
RETAIL	2.8571

--To clean the data, rename the column to remove the space, and set the correct data type

SET SQL_SAFE_UPDATES = 0;

-- 1. Convert text to date by checking for both slashes and dashes
UPDATE proj_table 
SET `START _DATE` = CASE 
    WHEN `START _DATE` LIKE '%/%' THEN STR_TO_DATE(`START _DATE`, '%m/%d/%Y')
    WHEN `START _DATE` LIKE '%-%' THEN STR_TO_DATE(`START _DATE`, '%m-%d-%Y')
    ELSE `START _DATE` 
END;

-- 2. Rename the column to remove the space 
ALTER TABLE proj_table 
CHANGE COLUMN `START _DATE` `START_DATE` TEXT;

-- 3. Change the column to proper DATE type
ALTER TABLE proj_table 
MODIFY COLUMN `START_DATE` DATE;

SET SQL_SAFE_UPDATES = 1;

 --Retrieve all employee records
SELECT * FROM emp_record_table;

--List employees with full names
SELECT EMP_ID,
       CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,
       ROLE, DEPT, COUNTRY
FROM emp_record_table;

*** salary and compensations
Find the maximum salary
SELECT MAX(SALARY) AS MAX_SALARY
FROM emp_record_table;

--Find employees earning the maximum salary
SELECT *
FROM emp_record_table
WHERE SALARY = (SELECT MAX(SALARY) FROM emp_record_table);


-- Calculate bonus (e.g., 10%) for all employees

SELECT EMP_ID,
       FIRST_NAME,
       SALARY,
       SALARY * 0.10 AS BONUS
FROM emp_record_table;

-- avg salary bye dept
SELECT DEPT, AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY DEPT;

--list emp's with rating abpve 4
SLECT EMP_ID, FIRST_NAME, LAST_NAME, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;

Average rating by department
SELECT DEPT, AVG(EMP_RATING) AS AVG_RATING
FROM emp_record_table
GROUP BY DEPT;

--top 5 highest-rated employees
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EMP_RATING
FROM emp_record_table
ORDER BY EMP_RATING DESC
LIMIT 5;

*** Count employees under each manager
SELECT MANAGER_ID, COUNT(*) AS TEAM_SIZE
FROM emp_record_table
GROUP BY MANAGER_ID;

--List employees with their manager names
SELECT e.EMP_ID,
       e.FIRST_NAME AS EMPLOYEE,
       m.FIRST_NAME AS MANAGER
FROM emp_record_table e
LEFT JOIN emp_record_table m
ON e.MANAGER_ID = m.EMP_ID;


--List all projects
SELECT * FROM proj_table;
SELECT e.EMP_ID,
       e.FIRST_NAME,
       p.PROJ_Name,
       p.DOMAIN
FROM emp_record_table e
JOIN proj_table p
ON e.PROJ_ID = p.PROJECT_ID;


--Count employees per project
SELECT PROJ_ID, COUNT(*) AS EMP_COUNT
FROM emp_record_table
GROUP BY PROJ_ID;

--  Projects that are still active
SELECT *
FROM proj_table
WHERE STATUS = 'Active';


-- Greography insights
SELECT COUNTRY, COUNT(*) AS EMP_COUNT
FROM emp_record_table
GROUP BY COUNTRY;

--employee count by continent
SELECT CONTINENT, COUNT(*) AS EMP_COUNT
FROM emp_record_table
GROUP BY CONTINENT;

-- Data science 
List all Data Science team members
SELECT * FROM data_science_team;

-- Compare Data Science team salaries with overall average
SELECT d.EMP_ID,
       d.FIRST_NAME,
       d.SALARY,
       (SELECT AVG(SALARY) FROM emp_record_table) AS OVERALL_AVG_SALARY
FROM data_science_team d;

--HR focused insights
--Identify employees needing training (rating < 3)
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 3;

--Employees with high experience but low rating
SELECT EMP_ID, FIRST_NAME, EXP, EMP_RATING
FROM emp_record_table
WHERE EXP > 5 AND EMP_RATING < 3;

--Department‑wise performance summary
SELECT DEPT,
       COUNT(*) AS TOTAL_EMP,
       AVG(EMP_RATING) AS AVG_RATING,
       AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY DEPT;




*************** CTE*************
-- top 5  highest paid sal
WITH TopSalaries AS (
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY,
           ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS rn
    FROM emp_record_table
)
SELECT *
FROM TopSalaries
WHERE rn <= 5;

-- Average Salary by Department
WITH DeptSalary AS (
    SELECT DEPT, AVG(SALARY) AS AVG_SAL
    FROM emp_record_table
    GROUP BY DEPT
)
SELECT * FROM DeptSalary;

-- Employees Needing Training (Rating < 3)
WITH LowPerformers AS (
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, EMP_RATING, EXP
    FROM emp_record_table
    WHERE EMP_RATING < 3
)
SELECT *
FROM LowPerformers
ORDER BY EXP DESC;

--Project Duration in Days
WITH ProjectDuration AS (
    SELECT PROJECT_ID,
           PROJ_Name,
           DATEDIFF(CLOSURE_DATE, START_DATE) AS DURATION_DAYS
    FROM proj_table
)
SELECT * FROM ProjectDuration;

-- JOINS (Employee ↔ Project ↔ Manager)
--Employee with Project Details
SELECT e.EMP_ID,
       e.FIRST_NAME,
       e.ROLE,
       p.PROJ_Name,
       p.DOMAIN,
       p.STATUS
FROM emp_record_table e
JOIN proj_table p
ON e.PROJ_ID = p.PROJECT_ID;



-- Employee with Manager Name
SELECT e.EMP_ID,
       CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS EMPLOYEE,
       CONCAT(m.FIRST_NAME, ' ', m.LAST_NAME) AS MANAGER
FROM emp_record_table e
LEFT JOIN emp_record_table m
ON e.MANAGER_ID = m.EMP_ID;



-- Employees in Data Science Team with Salary Comparison
SELECT d.EMP_ID,
       d.FIRST_NAME,
       d.ROLE,
       e.SALARY AS ORG_SALARY
FROM data_science_team d
JOIN emp_record_table e
ON d.EMP_ID = e.EMP_ID;



-- Project-wise Employee Count
SELECT p.PROJ_Name,
       COUNT(e.EMP_ID) AS EMP_COUNT
FROM proj_table p
LEFT JOIN emp_record_table e
ON p.PROJECT_ID = e.PROJ_ID
GROUP BY p.PROJ_Name;



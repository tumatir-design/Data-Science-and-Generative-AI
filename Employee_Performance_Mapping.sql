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


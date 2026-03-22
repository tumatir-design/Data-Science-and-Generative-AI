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

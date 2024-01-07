/*-------------------------------PROJECT ON ANALYSIS OF EMPLOYEES DATABASE*-----------------------------------*/

/*------------------------------------------------------------------------------------------------------------*/
-- OVERVIEV OF ALL TABLES 
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 1.Employee Demographics:
-- A. What is the distribution of employees based on gender?
SELECT 
    COUNT(emp_no) AS Total_Employees, gender
FROM
    employees
GROUP BY gender;
--------------------------------------------------------------------------------------------
-- B. What is the average age of employees in each department?
SELECT 
    d.dept_name,
    ROUND(AVG(YEAR(CURDATE()) - YEAR(e.birth_date)), 2) AS Average_age_of_employees
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
        JOIN
    employees e ON e.emp_no = de.emp_no
GROUP BY d.dept_name;

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- 2. Salary Analysis:
-- A. How has the average salary changed over the years?
SELECT 
    YEAR(from_date) AS years,
    ROUND(AVG(salary), 2) AS Average_salary
FROM
    salaries
GROUP BY years
ORDER BY years ASC;
-----------------------------------------------------------------
-- B. Which department has the highest average salary?
SELECT 
    d.dept_name, ROUND(AVG(s.salary), 2) AS Avg_salary
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
        JOIN
    salaries s ON s.emp_no = de.emp_no
GROUP BY d.dept_no
ORDER BY Avg_salary DESC
LIMIT 1;
------------------------------------------------------------------
-- C. Identify employees with the highest and lowest salaries.
WITH RankedSalaries AS (
  SELECT
    e.first_name,e.last_name, e.emp_no,
    s.salary,
    RANK() OVER (ORDER BY s.salary DESC) AS max_salary_rank,
    RANK() OVER (ORDER BY s.salary) AS min_salary_rank
  FROM
    employees e
    JOIN salaries s ON e.emp_no = s.emp_no
)
SELECT *
FROM RankedSalaries
WHERE max_salary_rank = 1 OR min_salary_rank = 1;

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- 3. Employee Titles:
-- A. What are the most common job titles in the company?
SELECT 
    title AS Most_common_job_title, COUNT(title) AS Total_jobs
FROM
    titles
GROUP BY title
ORDER BY Total_jobs DESC;
-----------------------------------------------------------------------
-- B. How often do employees change their job titles?
SELECT
    emp_no,
    COUNT(*) AS title_changes
FROM
    titles
GROUP BY
    emp_no
HAVING
    COUNT(*) > 1;
--------------------------------------------------------------------
-- C. Identify employees who have held the most number of titles.
SELECT
    emp_no,
    COUNT(DISTINCT title) AS most_titles
FROM
    titles
GROUP BY
    emp_no
HAVING
    COUNT(*) > 1
ORDER BY most_titles DESC
LIMIT 1;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

-- 4. Department Information:
-- A. How many employees are currently assigned to each department?
SELECT 
    d.dept_name, COUNT(e.emp_no) AS Total_employees
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
        JOIN
    employees e ON e.emp_no = de.emp_no
GROUP BY d.dept_name
ORDER BY Total_employees;
--------------------------------------------------------------------------
-- B. Which department has had the most managers over time?
SELECT 
    d.dept_name, COUNT(dm.emp_no) MOST_MANAGER
FROM
    departments d
        INNER JOIN
    dept_manager dm ON d.dept_no = dm.dept_no
GROUP BY d.dept_name
ORDER BY MOST_MANAGER DESC
LIMIT 1;

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 5. Managerial Analysis:
-- A. Who are the current managers in each department?
SELECT 
    dm.dept_no, d.dept_name, e.emp_no, e.first_name, e.last_name
FROM
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
WHERE
    dm.to_date = '9999-01-01'; -- Assuming '9999-01-01' represents the current date
--------------------------------------------------------------------------------------
-- B. How many times has each employee served as a manager?
SELECT 
    emp_no, COUNT(*) AS manager_count
FROM
    dept_manager
GROUP BY emp_no
ORDER BY manager_count DESC;

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

-- 6. Hiring Trends:
-- A. How has the number of new hires changed over the years?
SELECT 
    YEAR(hire_date) AS hire_year, COUNT(*) AS new_hires_count
FROM
    employees
GROUP BY hire_year
ORDER BY hire_year;
----------------------------------------------------------------------------
-- B. Identify the departments with the highest and lowest hiring rates.
SELECT 
    d.dept_no,
    d.dept_name,
    COUNT(DISTINCT e.emp_no) AS total_employees,
    COUNT(DISTINCT CASE
            WHEN YEAR(e.hire_date) = YEAR(CURDATE()) THEN e.emp_no
        END) AS new_hires,
    COUNT(DISTINCT CASE
            WHEN YEAR(e.hire_date) = YEAR(CURDATE()) THEN e.emp_no
        END) / COUNT(DISTINCT e.emp_no) AS hiring_rate
FROM
    departments d
        JOIN
    dept_emp de ON d.dept_no = de.dept_no
        JOIN
    employees e ON de.emp_no = e.emp_no
GROUP BY d.dept_no , d.dept_name
ORDER BY hiring_rate DESC;

-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

-- 7. Employee Longevity:
-- A. What is the average tenure of employees in the company?
SELECT
    AVG(DATEDIFF(CURDATE(), hire_date)) AS average_tenure
FROM
    employees;
------------------------------------------------------------------------------
-- B. Identify employees who have been with the company the longest.
SELECT 
    emp_no, first_name, last_name, hire_date, DATEDIFF(CURDATE(), hire_date) AS tenure_days
FROM
    employees
ORDER BY tenure_days DESC
LIMIT 1;
-----------------------------------------------------------------------------
-- C. How many employees have retired or left the company in recent years?
SELECT
    COUNT(*) AS employees_left
FROM
    dept_emp
WHERE
    to_date < CURDATE();


/*------------------------------------------||PROJECT CONCLUDED||--------------------------------------------------------*/






# SQL_Important_Prcactice_Questions
40+ SQL important Questions for Job purpose...
SQL Practice Queries - Employee & Department Management
This repository contains a collection of SQL queries designed to solve common database problems, ranging from basic filtering to advanced window functions and analytical tasks. These queries were practiced using an Employee and Department database schema.

🚀 Overview
The project covers essential SQL concepts frequently asked in technical interviews and used in day-to-day data analysis.

Topics Covered:
Ranking & Window Functions: Finding Nth highest salary, department-wise toppers, and running totals.

Aggregations: Grouping by departments, calculating average differences, and filtering using HAVING.

Joins: Inner, Left, Self, and Cross joins to connect employees with departments and managers.

Data Cleaning: Finding and deleting duplicate records using ROW_NUMBER().

String & Date Operations: Pattern matching (LIKE), string trimming, and extracting year/month from dates.

Advanced Logic: Using CASE statements for data pivoting and conditional updates.

📊 Database Schema (Conceptual)
The queries assume two primary tables:

employees: Contains empid, name, salary, deptid, managerid, gender, and joiningdate.

departments: Contains deptid and deptname.

🛠️ Key Query Highlights
1. Finding the 2nd Highest Salary
Using a subquery approach for compatibility:

SQL

SELECT MAX(salary) AS secondhighsalary 
FROM employees 
WHERE salary < (SELECT MAX(salary) FROM employees);
2. Department-wise Top Earners
Using DENSE_RANK() to handle salary ties:

SQL

SELECT name, salary, deptid FROM ( 
    SELECT name, salary, deptid, 
    DENSE_RANK() OVER (PARTITION BY deptid ORDER BY salary DESC) AS rnk1 
    FROM employees
) t WHERE rnk1 = 1;
3. Cumulative Salary (Running Total)
SQL

SELECT name, salary, 
SUM(salary) OVER (ORDER BY empid) AS running_total
FROM employees;
4. Handling Duplicates
Identifying duplicate names in the table:

SQL

SELECT name, COUNT(*) 
FROM employees
GROUP BY name
HAVING COUNT(*) > 1;
📝 SQL Query Execution Order
Understanding how the database engine processes your code is crucial for optimization:

FROM & JOIN

WHERE

GROUP BY

HAVING

SELECT

DISTINCT

ORDER BY

LIMIT

📂 File Structure
practicedatabase_ques.sql: Contains the full SQL script with all practice questions and multiple logic methods.

🤝 Contribution
If you have better ways to optimize these queries or want to add more complex scenarios, feel free to fork this repo and submit a PR!

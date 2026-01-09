select * from departments;
select * from employees;

-- Practice Start
-- 1. 2nd Highest Salary: Find the second highest salary from the Employee table. 

select max(salary)  as secondhighsalary from employees 
where salary < ( select max(salary) from employees);

-- method 2

select distinct salary from employees
order by salary desc
limit 1 offset 1;

/* Nth Highest Salary: Write a generic query to find the Nth highest salary (e.g., 5th 
or 10th).*/

select salary from (
select salary, dense_rank() over (order by salary desc) as rnk
 from employees)t
 where rnk = 1;

  /*Department-wise Highest Salary: Har department mein sabse zyada kamane 
wala employee kaun hai? */

select name, salary, deptid from ( 
select name, salary, deptid, dense_rank() over (partition by deptid 
order by salary desc)as rnk1 from employees) t
where rnk1 = 3;

/*Top 3 Salaries per Department: Har department ke top 3 earners kaun hain? 
(Window Function lagega). */

select name, salary, deptid from(
select name, salary, deptid, dense_rank() over (partition by deptid order by salary ) as rank1
 from employees) t
 where salary >=3
 order by  deptid, salary desc

 /* Above Average Salary: Un employees ke naam batao jinki salary company ki 
average salary se zyada hai.*/

select name, salary from employees
where salary >( select avg(salary) from employees)

/* Salary Difference: Employee ki salary aur uske department ki average salary ka 
difference nikalo. */

select name, deptid, salary, salary - avg(salary) over (partition by deptid)as salary_defference
from employees;

/*Same Salary: Wo employees dhoondo jinki salary bilkul same hai. */

select name, salary from employees
where salary in(select salary
from employees
group by salary
having count(*) > 1
) order by salary;

/* Max & Min: Ek query mein har department ki maximum aur minimum salary 
show karo. */
select deptid, max(salary) as max_salary,
min(salary) as min_salary
from employees 
group by deptid
order by deptid asc

/* Cumulative Salary: Har row mein pichli rows ki salary judti hui dikhe (Running 
Total).*/

select name, salary, sum(salary) over (order by empid) as running_total
from employees;

/*  Hike Calculation: Agar sabki salary 10% badha di jaye, to nayi salary kya hogi 
display karo (Update nahi karna, bas Select mein dikhana hai).*/

select name, salary as old_salary,
salary * 1.10 as new_salary
from employees

/* . Find Duplicates: Table mein duplicate records kaise dhoondoge? */

select name, count(*) from employees
group by name
having count(*) > 1;
-- second method

select * from
( select *, row_number() over(partition by name, deptid, salary order by empid)as run
from employees) t
where run > 1;

/* . Delete Duplicates: Duplicate rows ko delete kaise karoge taaki sirf ek unique 
row bache? */

delete from employees
where empid in( select empid from 
(select empid, row_number() over(partition by name, deptid, salary order by empid) as runk
from employees) t
where runk > 1
);

/* Count Duplicates: Kis naam ke kitne duplicates hain, count nikalo. */
 select name, count(*) as duplicate_name 
 from employees
 group by name 
 having count(*) > 1

 /*  Replace NULL: Select query mein jahan NULL ho wahan "No Value" ya 0 kaise 
dikhaoge? (COALESCE ya ISNULL function */

select name, coalesce(managerid, 0) as managerid
from employees

/* Not Null Check: Wo records nikalo jahan koi bhi column khali na ho.*/

select * from employees 
where name is not null
and managerid is not null
and deptid is not null
and salary is not null

/*  First/Last Record: Table ka sabse pehla aur sabse aakhri record kaise fetch 
karoge? */

select * from employees 
order by empid desc
limit 1;

select * from employees 
 order by empid asc
 limit 1;

 -- method 2 by window function

 select * from(
select *, row_number() over (order by empid asc) as run_first,
          row_number() over (order by empid desc) as last_first
		  from employees ) t
		  where run_first = 1
		  or last_first = 1

/*  Alternate Records: Sirf Odd (1,3,5) ya Even (2,4,6) number wali rows kaise 
nikaloge? */
-- 1
select * from(
select *, row_number() over(order by empid) as rnk from employees) t
 where rnk % 2 = 1

-- 2
select * from
(select *, row_number() over(order by empid) as rnk from employees) t 
where rnk % 2 = 0

/* Copy Table: Ek table ka pura data doosri nayi table mein kaise copy karoge?*/

create table employees_backup as 
select * from employees

/*  Common Records: Do tables mein jo common data hai (Intersection), wo kaise 
nikaloge? */ 

select e.*
from employees e
inner join departments d
on e.deptid = d.deptid

/* . Employee & Department: Employee ka naam aur uske Department ka naam 
show karo (Inner Join). */

select e.name, d.deptname
from employees e
inner join departments d
on e.deptid = d.deptid

/*  All Employees: Sare employees dikhao, chahe unka department ho ya na ho 
(Left Join). */ 

select e.name, d.deptname
from employees e
left join departments d
on e.deptid = d.deptid

/*  Employees without Dept: Wo employees dhoondo jo kisi department mein nahi 
hain (IS NULL in Join).*/

select e.name, d.deptname
from employees e
left join departments d
on e.deptid = d.deptid
where d.deptid is null

/*  Depts without Employees: Wo department dhoondo jisme koi employee kaam 
nahi karta. */

select d.deptname
from departments d
left join employees e
on d.deptid = e.deptid
where empid is null

/*  Self Join (Manager): Employee ka naam aur uske Manager ka naam ek hi row 
mein dikhao. */ 

select e.name as employees_name,
m.name as manager_name 
from employees e
left join employees m
on e.empid = m.managerid

/*  Manager with Salary > Employee: Wo managers dhoondo jinki salary unke 
under kaam karne wale employee se kam hai (Tricky Self Join). */

select distinct 
m.empid as manager_id,
m.name as manager_name,
m.salary as manager_salary,
e.name as employee_name,
e.salary as employee_salary
from employees e
join employees m
on e.managerid = m.empid
where e.salary > m.salary

/*  Cross Join: Agar Table A mein 5 rows hain aur Table B mein 5, to Cross Join mein 
kitni rows aayengi? */

select e.name as employee_name, 
d.deptname as department_name
from employees e
cross join departments d

/* Three Table Join: Employee, Department, aur Location tables ko ek saath kaise 
join karoge? */

-- we don't have three tables

/*  Unmatched Records: Wo data nikalo jo Table A mein hai par Table B mein nahi 
(Minus/Except).*/

select e.*
from employees e
left join departments d
on e.deptid = d.deptid
where d.deptid is null

/*  Names starting with 'A': Wo naam dhoondo jo 'A' se shuru hote hain. */

select name from employees
where name like '%A%'

/*  Contains 'a': Wo naam dhoondo jinke beech mein kahin bhi 'a' aata ho. */

select name from employees
where name like '%a%'

/* . Exact Length: Wo naam dhoondo jinke naam mein exactly 5 letters hain 
(LENGTH or _ _ _ _ _). */

select name from employees 
where length(name) = 5

/*  Last 3 Characters: Kisi ke naam ke aakhri 3 letters kaise nikaloge? */

select name, right(name, 3) as last3_name
 from employees

/*  Trim Spaces: Agar naam ke aage-peeche space hai to usse kaise hataoge? 
(LTRIM, RTRIM) */

-- both side (left, right)
select trim(name)as clean_name
from employees
-- left side
select Ltrim(name) as clean_name 
from employees
-- right side
select Rtrim(name) as clean_name
from employees

/*  Joining Month: Wo employees dhoondo jinhone 'January' mein join kiya. */

select name, joiningdate
from employees
where extract(month from joiningdate) = 1

/*  Joined in 2024: Sirf 2024 mein join karne wale log */
 select name, joiningdate
 from employees
 where extract(year from joiningdate) = 2024

 /*  Date Difference: Date of Joining aur aaj ki date mein kitne din ka fark hai? */

 select name, current_date - joiningdate as difference_date
 from employees

 /* . Count per Dept: Har department mein kitne log hain?*/

select d.deptname, count(e.empid) as employee_count
from departments d
left join employees e
on d.deptid = e.deptid
group by d.deptid

/*  Having Clause: Sirf wo department dikhao jahan 5 se zyada log kaam karte hain. */

select deptid, count(*) as total_employees
from employees 
group by deptid
having count(*) > 3

/*  Job-wise Sum: Har Job role ki total salary kitni ja rahi hai */

select deptid, sum(salary) from employees
group by deptid

/* Multiple Groups: Department aur Gender ke hisaab se count nikalo (kitne 
male/female har dept mein). */

select deptid, gender, count(*) as total_employee
from employees
group by deptid, gender

/* . Unique Depts: Kitne alag-alag departments exist karte hain (Distinct Count). */

select count( distinct deptid) as total_departments
from employees

/*  Filter Aggregation: Average salary nikalo, par manager ko count mat karna. */

select avg(salary) as avg_salary
from employees
where managerid is not null

/*  Pivot Data (Advanced): Rows ko Columns mein badalna (Case statement use 
karke).*/

select
sum(case when deptid = 1 then salary else 0 end) as it_salary,
sum(case when deptid = 2 then salary else 0 end) as hr_salary,
sum(case when deptid = 3 then salary else 0 end) as sales_salary,
sum(case when deptid = 4 then salary else 0 end) as admin_salary
from employees

/*  Swap Values: Gender column mein 'Male' ko 'Female' aur 'Female' ko 'Male' kar 
do (Update with Case).*/

update employees
set gender = 
case 
when gender = 'Male' then 'Female'
when gender = 'Female' then 'Male'
else gender
end

/* Query Execution Order: Query kis order mein run hoti hai? (Yeh interview 
question hai, par query likhte waqt logic yahi lagta hai)*/

/* 
1️⃣ FROM
2️⃣ JOIN / ON
3️⃣ WHERE
4️⃣ GROUP BY
5️⃣ HAVING
6️⃣ SELECT
7️⃣ DISTINCT
8️⃣ ORDER BY
9️⃣ LIMIT / TOP
*/

SELECT deptid, AVG(salary) AS avg_salary
FROM employees
WHERE salary > 30000
GROUP BY deptid
HAVING AVG(salary) > 40000
ORDER BY avg_salary DESC
LIMIT 3;

-- FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

/* Create View: In sab queries ko baar-baar likhne se bachne ke liye View kaise 
banaoge? */

CREATE VIEW vw_high_salary_employees AS
SELECT empid, name, salary, deptid
FROM employees
WHERE salary > 50000;

select * from vw_high_salary_employees


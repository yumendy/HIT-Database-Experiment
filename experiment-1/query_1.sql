use company;

-- 1.1 参加了项目名为“SQL Project”的员工名字；

SELECT DISTINCT employee.ename
FROM employee
JOIN works_on ON employee.essn = works_on.essn
JOIN project ON project.pno = works_on.pno
WHERE project.pname='SQL Project';

-- 1.2 在“Research Department”工作且工资低于3000元的员工名字和地址；

SELECT DISTINCT employee.ename, employee.address
FROM employee
JOIN department ON employee.dno = department.dno
WHERE department.dname =  'Research Department'
AND employee.salary < 3000;

-- 1.3 没有参加项目编号为P1的项目的员工姓名；

SELECT DISTINCT employee.ename
FROM employee
LEFT JOIN (
  SELECT DISTINCT employee.ename
  FROM employee
  JOIN works_on ON employee.essn = works_on.essn
  WHERE works_on.pno =  'P1'
) AS B ON employee.ename = B.ename
WHERE B.ename IS NULL

-- 1.4 由张红领导的工作人员的姓名和所在部门的名字；

SELECT DISTINCT employee.ename, B.dname
FROM employee
JOIN (
  SELECT DISTINCT department.dname, department.dno, employee.ename
  FROM department
  JOIN employee ON department.mgrssn = employee.essn
  WHERE employee.ename =  '张红'
) AS B ON employee.dno = B.dno

-- 另一种写法

SELECT DISTINCT
    e.ename, department.dname
FROM
    employee AS e
        JOIN
    (department
    JOIN employee AS m ON department.mgrssn = m.essn) ON e.dno = department.dno
WHERE
    m.ename = '张红'

-- 1.5 至少参加了项目编号为P1和P2的项目的员工号；

SELECT
    a_essn
FROM
    (SELECT
        works_on.essn AS a_essn, works_on.pno AS a_pno
    FROM
        works_on) AS A
        JOIN
    (SELECT
        works_on.essn AS b_essn, works_on.pno AS b_pno
    FROM
        works_on) AS B ON A.a_essn = B.b_essn
WHERE
    a_pno = 'P1' AND b_pno = 'P2';

-- 另一种方法

SELECT
    A.essn
FROM
    works_on AS A,
    works_on AS B
WHERE
    A.essn = B.essn AND A.pno = 'P1'
        AND B.pno = 'P2';

-- 1.6 参加了全部项目的员工号码和姓名；

SELECT
    employee.essn, employee.ename
FROM
    (works_on
    JOIN employee ON works_on.essn = employee.essn)
GROUP BY essn
HAVING COUNT(pno) = (SELECT
        COUNT(*)
    FROM
        project);

-- 1.7 员工平均工资低于3000元的部门名称；

SELECT
    department.dname
FROM
    (employee
    JOIN department ON employee.dno = department.dno)
GROUP BY department.dno
HAVING AVG(employee.salary) < 3000;

-- 1.8 至少参与了3个项目且工作总时间不超过8小时的员工名字；

SELECT
    employee.ename
FROM
    (works_on
    JOIN employee ON works_on.essn = employee.essn)
GROUP BY employee.essn
HAVING COUNT(pno) >= 3 AND SUM(hours) <= 8;

-- 1.9 每个部门的员工小时平均工资；

SELECT
    department.dno,
    department.dname,
    SUM(salary) / SUM(personal_work_time)
FROM
    (SELECT
        employee.essn,
            employee.dno,
            employee.salary,
            SUM(works_on.hours) AS personal_work_time
    FROM
        employee
    JOIN works_on ON employee.essn = works_on.essn
    GROUP BY essn) AS B
        JOIN
    department ON B.dno = department.dno
GROUP BY B.dno;

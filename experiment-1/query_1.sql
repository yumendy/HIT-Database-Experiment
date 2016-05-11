use company;

-- 1.1 参加了项目名为“哈同公路”的员工名字；

SELECT DISTINCT employee.ename
FROM employee
JOIN works_on ON employee.essn = works_on.essn
JOIN project ON project.pno = works_on.pno
WHERE project.pname='哈同公路';

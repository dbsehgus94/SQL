--21년 6월 2일 수업내용
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id;

SELECT department_id, department_name
FROM departments a
WHERE EXISTS(SELECT *
            FROM employees b
            WHERE a.department_id = b.department_id
            AND b.salary > 3000)
ORDER BY a.department_name;

SELECT department_id, department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                            FROM employees b
                            WHERE b.salary > 3000)
ORDER BY department_name;

SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
AND b.salary > 3000
ORDER BY a.department_name;

SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id
AND a.department_id NOT IN ( SELECT department_id
                            FROM departments
                            WHERE manager_id IS NULL);

SELECT COUNT(*)
FROM employees a
WHERE NOT EXISTS( SELECT 1
                    FROM departments c
                    WHERE a.department_id = c.department_id
                    AND manager_id IS NULL);

SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
FROM employees a,
    employees b
WHERE a.employee_id < b.employee_id
AND a.department_id = b.department_id
AND a.department_id = 20;

SELECT a.department_id, a.department_name, b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id;

SELECT a.department_id, a.department_name, b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id(+);

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id;

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b;
    
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b.department_id
AND a.hire_date>=TO_DATE('2003-01-01', 'YYYY-MM-DD');

SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01', 'YYYY-MM-DD');


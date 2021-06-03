--21�� 6�� 3�� ��������
--���� ����(�ܺ�����)
select a.employee_id, a.emp_name, b.job_id, b.department_id
from employees a,
    job_history b
where a.employee_id = b.employee_id(+)
and a.department_id = b.department_id(+);

--ANSI ����(LEFT JOIN)
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT OUTER JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--ANSI ����(RIGHT JOIN)    
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--OUTER ���� ����
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--WHERE ���� ���� ������ ������� ���� īŸ�þ� ������ �ִµ�, ANSI ���ο����� CROSS �����̶�� �Ѵ�.
--���� ����
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b;
    
--ANSI ����
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;

--���̺� ���� �� �� ���� �� Ŀ��
CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);
INSERT INTO HONG_A VALUES( 10);
INSERT INTO HONG_A VALUES( 20);
INSERT INTO HONG_A VALUES( 40);
INSERT INTO HONG_B VALUES( 10);
INSERT INTO HONG_B VALUES( 20);
INSERT INTO HONG_B VALUES( 30);
COMMIT;

--����: OUTER-JOIN�� ���̺��� 1���� ������ �� �ִ�.
--�ܺ� ���� ���ǿ����� �� �ʿ��� (+)�� ���� �� �ִ�.
SELECT a.emp_id, b.emp_id
FROM hong_a a,
    hong_b b
WHERE a.emp_id(+) = b.emp_id(+);

--FULL JOIN ���
--FULL -> �� ���̺� ��θ� �ܺ� ���� ��� ���� �� �ִ�.
SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
ON (a.emp_id = b.emp_id);

--���� ����
--������������ �������� ���� ���� ����
--���� ���̺�� ���� ������ �ɸ��� ����

--���� �������� ���� ��� �޿��� ���� �� ���� ���������� �� ��հ����� ū ����� ��ȸ
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary)
    FROM employees);
--���� ���� �������� ���� ���� ��ȯ������ ���� ���� ������ ���� ���� ��ȯ�ߴ�.
SELECT count(*)
FROM employees
WHERE department_id IN ( SELECT department_id
                           FROM departments
                          WHERE parent_id IS NULL);

--���ÿ� 2�� �̻��� �÷� ���� ���� ���� ã�� �ִ�. 
--IN �տ� �ִ� �÷� ������ ���� �������� ��ȯ�ϴ� �÷� ������ ������ ���ƾ� �Ѵ�.
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                FROM job_history);

--�� ����� �޿��� ��� �ݾ����� ����(UPDATE��)
UPDATE employees
SET salary = ( SELECT AVG(salary)
                 FROM employees);
                 
--��� �޿����� ���� �޴� ��� ����(DELETE��)
DELETE employees
WHERE salary >= ( SELECT AVG(salary)
                    FROM employees);

--��� ���̺��� �� ���·� �ǵ��� ������ ROLLBACK ���� ����.
ROLLBACK;

--������ �ִ� ���� ����(���� �������� �������� �ִ� ���� ����, �� ���� ���̺� �� ���� ������ �ɸ� ���� ����)

--���� ���� �ȿ��� ���� �������� ���� �μ� ���̺��� �μ���ȣ��
--job_history ���̺��� �μ���ȣ�� ���� ���� ��ȸ�ϰ� �ִ�.
--EXISTS �����ڸ� ����Ͽ� ���� ���� ���� ���� ������ ���Ե�.
--������� job_history ���̺� �ִ� �μ��� ��ȸ��.
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS( SELECT 1
                FROM job_history b
               WHERE a.department_id = b.department_id);

--job_history�� ���, �μ���ȣ�� �����ϹǷ� ������ �μ����� �������� ����
--���� ������ SELECT ������ ����߰�, ���� ���� ���� WHERE ���� ������ �߰���.
--SELECT �� ��ü������ ���� ���� ���� ������ ���� �� ����.
--�� ���� ������ �������̹Ƿ� �� ���� ���� �������� ���� ���, �μ� ���̺��� ��Ī�� ���
--b�� ����ص� ������.
SELECT a.employee_id,
    ( SELECT b.emp_name
        FROM employees b
        WHERE a.employee_id = b.employee_id) AS emp_name,
    a.department_id,
    ( SELECT b.department_name
        FROM departments b
        WHERE a.department_id = b.department_id) AS dep_name
    FROM job_history a;

--2���� ���� ������ ����.
--(SELECT AVG(salary) FROM employees)���� ��ձ޿��� ���ϰ�
--�� ������ ū �޿��� ����� �ɷ��� ����(������ ���� ���� ����)
--WHERE a.department_id = b.department_id ���� ��ձ޿� �̻��� �޴� 
--����� ���� �μ��� ������ ��(������ �ִ� ���� ����).                                  
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS ( SELECT 1
                FROM employees b
                WHERE a.department_id = b.department_id
                AND b.salary > ( SELECT AVG(salary)
                                    FROM employees)
            );

--�μ� ���̺��� ���� �μ��� ��ȹ��(�μ���ȣ�� 90)�� ���ϴ� ������� �μ��� ��� �޿��� ��ȸ
SELECT department_id, AVG(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                          FROM departments
                          WHERE parent_id=90)
GROUP BY department_id;

--���� �μ��� ��ȹ�ο� ���ϴ� ��� ����� �޿��� �ڽ��� �μ��� ��ձ޿��� �����ϴ� ����.
UPDATE employees a
    SET a.salary = (SELECT sal
                                FROM (SELECT b.department_id, AVG(c.salary) as sal
                                                FROM departments b,
                                                            employees c
                                                WHERE b.parent_id = 90
                                                     AND b.department_id = c.department_id
                                                GROUP BY b.department_id) d
                                WHERE a.department_id = d.department_id)
    WHERE a.department_id IN (SELECT department_id
                                                    FROM departments
                                                    WHERE parent_id = 90);

--�μ��� �ּҿ� �ִ� �ݾ��� ��� ����, ������ ���� �μ��� ��հ����� ���ŵǾ����Ƿ� ����� ó����.
SELECT department_id, MIN(salary), MAX(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                                            FROM departments
                                        WHERE parent_id = 90)
GROUP BY department_id;
 
 --MERGE������ ����.
MERGE INTO employees a
USING (SELECT b.department_id, AVG(c.salary) as sal
                FROM departments b,
                            employees c
                WHERE b.parent_id = 90
                AND b.department_id = c.department_id
                GROUP BY b.department_id) d
            ON  (a.department_id = d.department_id)
WHEN MATCHED THEN
UPDATE SET a.salary = d.sal;

--������ �����͸� �� ���·� �ǵ��� ������ ROLLBACK���� ����.
ROLLBACK;

--�ζ��� ��(FROM ���� ����ϴ� ���� ����)
--���� ������ FROM ���� ����Ͽ� �ϳ��� ���̺��̳� ��ó�� ����� �� �ִ�.
--�並 ��ü�ϸ� �ϳ��� �������� SELECT���̹Ƿ� FROM ���� ����ϴ� ���� ������ �ϳ��� ��� �� �� �־� �ζ��� ���� �Ѵ�.

--��ȹ��(90) ���Ͽ� �ִ� �μ��� ���� ����� ��ձ޿����� ���� �޿��� �޴� �������� ������ ���ε�
--��ȹ�� ���� ��ձ޿��� ���ϴ� �κ��� ���� ������ �ۼ��߰� �̸� FROM ���� ��ġ��Ŵ.
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
            departments b,
            (SELECT AVG(c.salary) AS avg_salary
                FROM departments b,
                            employees c
                WHERE b.parent_id = 90 -- ��ȹ��
                AND b.department_id = c.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary;

--
SELECT a.*
FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
            FROM sales a,
                       customers b,
                       countries c
            WHERE a.sales_month BETWEEN '2200001' AND '200012'
                AND a.cust_id = b.CUST_ID
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- ��Ż����
            GROUP BY a.sales_month
            ) a,
            ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                    FROM sales a,
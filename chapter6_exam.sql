--1��. 101�� ����� ���� �Ʒ��� ����� �����ϴ� ������ �ۼ��� ����.
-- ��� ����� job��Ī job�������� job�������� job����μ���
SELECT a.employee_id AS ���, a.emp_name AS �����, d.job_title AS job��Ī, 
    c.start_date AS job��������, c.end_date AS job��������, b.department_name AS job����μ���
FROM employees a,
     departments b,
     job_history c,
     jobs d
WHERE a.employee_id = c.employee_id
  AND c.department_id = b.department_id
  AND c.job_id = d.job_id
  AND a.employee_id = 101;
  
--2��. �Ʒ��� ������ �����ϸ� ������ �߻��Ѵ�. ������ ������ �����ΰ�?
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id(+) = b.department_id;
--���� ���� : �� ���� ���̺��� outer-join �� �� �����ϴ�.
--�ܺ� ������ ���, �������ǿ� �����Ͱ� ���� ���̺��� �÷����� (+)�� �ٿ��� �Ѵ�.
--���� �� ������ ���, and a.department_id(+) = b.department_id �� �ƴ�
--a.department_id = b.department_id(+)�� ���ľ� �Ѵ�.
--����
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

--3��. �ܺ� ���ν� (+)�����ڸ� ���� ����� �� ���µ�, IN���� ����ϴ� ���� 1���� ����
--��� �����ϴ�. �� ������ �����ϱ�?
--����Ŭ�� IN ���� ���Ե� ���� �������� OR�� ��ȯ�Ѵ�.
--departmant_id IN (10, 20, 30)��
--department_id = 10
--OR department_id = 20
--OR department_id = 30���� �ٲپ� �� �� �ִ�.
--�׷��� IN���� ���� 1���� ���, �� department_id IN (10)�� ���
--department_id = 10���� ��ȯ�� �� �����Ƿ�, �ܺ������� �ϴ��� ���� 1���� ���� ����� �� �ִ�.

--4��. ������ ������ ANSI �������� ������ ����.
SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
AND b.salary > 3000
ORDER BY a.department_name;
--ANSI �������� ������ ����
SELECT a.department_id, a.department_name
FROM departments a
INNER JOIN employees b
    ON (a.department_id = b.department_id)
WHERE b.salary > 3000
ORDER BY a.department_name;

--5��. ������ ������ �ִ� ���������̴�. �̸� ������ ���� ���������� ��ȯ�� ����.
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
                FROM job_history b
               WHERE a.department_id = b.department_id);
--����
SELECT a.department_id, a.department_name
FROM departments a
WHERE a.department_id IN (SELECT department_id
                            FROM job_history);


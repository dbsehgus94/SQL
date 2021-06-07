--1��. ������ �� 3���� ����ϴ� �͸� ����� ����� ����.
--IS(AS)
--DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('3 * 1 = ' || 3); 
    DBMS_OUTPUT.PUT_LINE('3 * 2 = ' || 6);
    DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 9);
    DBMS_OUTPUT.PUT_LINE('3 * 4 = ' || 12);
    DBMS_OUTPUT.PUT_LINE('3 * 5 = ' || 15);
    DBMS_OUTPUT.PUT_LINE('3 * 6 = ' || 18);
    DBMS_OUTPUT.PUT_LINE('3 * 7 = ' || 21);
    DBMS_OUTPUT.PUT_LINE('3 * 8 = ' || 24);
    DBMS_OUTPUT.PUT_LINE('3 * 9 = ' || 27);
END;
/
--2��. ��� ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ� �͸� ����� ����� ����.
--IS(AS)
DECLARE
    vs_emp_name employees.emp_name%TYPE;
    vs_email employees.email%TYPE;
BEGIN
    SELECT emp_name, email
    INTO vs_emp_name, vs_email
    FROM employees
    WHERE employee_id = 201;
    
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_email);
END;
/
-- 3��. ��� ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� ��, �� '��ȣ+1'������ �Ʒ��� ����� ��� ���̺� �ű� �Է��ϴ� �͸� ����� ����� ����.
/*
<�����> : Harrison Ford
<�̸���> : HARRIS
<�Ի�����> : ��������
<�μ���ȣ> : 50
*/

--IS(AS)
DECLARE
    max_emp_id      employees.employee_id%TYPE;
    
BEGIN
    SELECT MAX(employee_id)
    INTO max_emp_id
    FROM employees;
    INSERT INTO employees(employee_id, emp_name, email, hire_date, department_id)
                    VALUES(max_emp_id+1, 'Harrison Ford', 'HARRIS', SYSDATE, 50);
    COMMIT;
    
END;
                            
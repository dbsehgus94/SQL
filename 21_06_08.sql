--IF��

/*
<������ 1���� ���>
IF ���� THEN
    ����ó��;
END IF;

<������ N���� ���>
IF ���� THEN
    ����ó�� 1;
ELSIF ����2 THEN
    ����ó�� 2;
...
ELSE
    ����ó��N;
END IF
*/
--vn_num2�� vn_num1���� ũ�Ƿ� else�κ����� ��� �Ѿ ����� ���� Ȯ���� �� �ִ�.
DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '�� ū��');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '�� ū��');
    END IF;
END;
/

--���� �͸� ����� ���� �����͸� ������ �� ����ߴ� DBMS_RANDOM ��Ű���� ����Ͽ� 10���� 120���� ���ڸ� ������ ��
--10�� �ڸ�(-1)���� ROUND ó���� �ؼ� ������ ������ �������� 10~120������ ���� vn_department_id ������ �Ҵ��Ѵ�.
--�� ���� ���� �ش��ϴ� �μ���ȣ�� ���� ����� �������� 1�� ������ �޿��� ������ vn_salary ������ �־�
--IF ���� ����Ͽ� ������ �°� ����ϴ� �����̴�.
DECLARE
    vn_salary NUMBER :=0;
    vn_department_id NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary
    INTO vn_salary
    FROM employees
    WHERE department_id = vn_department_id
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('�߰�');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ֻ���');
    END IF;
END;
/
--IF �� ��ø
--�͸����� ��� ���̺��� Ŀ�̼Ǳ��� ������ Ŀ�̼��� 0���� Ŭ ���
--�ٽ� ������ �ɾ� Ŀ�̼��� 0.15���� ũ�� '�޿�*Ŀ�̼�' ����� ����ϰ�
--Ŀ�̼��� 0���� ������ �޿��� ����ϰ� �����Ͽ���.
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_commission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary, commission_pct
    INTO vn_salary, vn_commission
    FROM employees
    WHERE department_id = vn_department_id
    AND ROWNUM=1;
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_commission > 0 THEN
        IF vn_commission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_salary);
    END IF;
END;
/

--CASE��
/*
<���� 1>
CASE ǥ����
    WHEN ���1 THEN
        ó����1;
    WHEN ���2 THEN
        ó����2;
    ...
    ELSE
        ��Ÿ ó����;

<���� 2>
CASE WHEN ǥ����1 THEN
        ó����1;
     WHEN ǥ����2 THEN
        ó����2;
     ...
     ELSE
        ��Ÿ ó����;
END CASE;
*/
--�޿��� ���� '����', '����'�� ����ϴ� IF���� CASE������ ��ȯ
DECLARE
    VN_SALARY NUMBER := 0;
    VN_DEPARTMENT_ID NUMBER := 0;
BEGIN
    VN_DEPARTMENT_ID := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT SALARY
    INTO VN_SALARY
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = VN_DEPARTMENT_ID
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(VN_SALARY);
    
    CASE WHEN VN_SALARY BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('����');
         WHEN VN_SALARY BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('�߰�');
         WHEN VN_SALARY BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('����');
         ELSE
            DBMS_OUTPUT.PUT_LINE('�ֻ���');
    END CASE;
END;
/

--LOOP��(�ݺ���)
/*
LOOP
    ó����;
    EXIT [WHEN ����]
END LOOP;
*/

--������ 3��(LOOP)
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '= ' || VN_BASE_NUM * VN_CNT);
        VN_CNT := VN_CNT + 1; -- LOOP�� ���鼭 VN_CNT ���� 1�� ������
        EXIT WHEN VN_CNT >9; -- VN_CNT�� 9���� ũ�� LOOP ����
    END LOOP;
END;
/

--WHILE��
/*
WHILE ����
LOOP
    ó����;
END LOOP;
*/

--������ 3��(WHILE)
--LOOP���� ������ ���� ������ ������ �־�����, WHILE�������� ������ �����ϴ� ������ �ش�.
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
WHILE VN_CNT <=9 -- VN_CNT�� 9���� �۰ų� ���� ���� �ݺ� ó��
LOOP
    DBMS_OUTPUT.PUT_LINE (VN_BASE_NUM || '*' || VN_CNT ||'= '||VN_BASE_NUM * VN_CNT);
    VN_CNT := VN_CNT + 1; -- VN_CNT ���� 1�� ����
END LOOP;
END;
/
--������(WHILE��, *5���� ǥ��)
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
WHILE VN_CNT <=9 -- VN_CNT�� 9���� �۰ų� ���� ���� �ݺ� ó��
LOOP
    DBMS_OUTPUT.PUT_LINE (VN_BASE_NUM || '*' || VN_CNT ||'= '||VN_BASE_NUM * VN_CNT);
    EXIT WHEN VN_CNT =5; -- VN_CNT ���� 5�� �Ǹ� ���� ����
    VN_CNT := VN_CNT + 1; -- VN_CNT ���� 1�� ����
END LOOP;
END;
/

--FOR��
/*
FOR �ε��� IN [REVERSE] �ʱ갪..������
LOOP
    ó����;
END LOOP;
*/

--������ 3��(FOR��)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR I IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
    END LOOP;
END;
/

--������ 3��(FOR��, REVERSE ���)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR I IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
    END LOOP;
END;
/

--CONTINUE��
--�ݺ��� ������ Ư�� ���ǿ� ������ �� ó�� ������ �ǳʶٰ� ����� ���� �������� �ǳʰ�
--������ ��� ������ �� ����Ѵ�.
--EXIT�� ������ ������ ������������, CONTINUE�� ���� ������ �������� �Ѿ��.

--������ 3��(FOR��, CONTINUE��, *5�� ���� ���)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR I IN 1..9
    LOOP
        CONTINUE WHEN I = 5;
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
    END LOOP;
END;
/

--GOTO��
--GOTO���� ������ GOTO���� �����ϴ� �󺧷� ��� �Ѿ��.
--�߰��߰� GOTO���� ����� ��� �ٸ� �κ����� �ѱ�� ������ �ϰ����� �ѼյǱ� ������
--GOTO���� �� ������� �ʴ´�.

--������ 3��(FOR��, GOTO��)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    <<THIRD>>
    FOR I IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
        IF I=3 THEN
            GOTO FOURTH;
        END IF;
    END LOOP;
    
    <<FOURTH>>
    VN_BASE_NUM := 4;
    FOR I IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I || '= ' || VN_BASE_NUM * I);
    END LOOP;
END;
/

--NULL��
--NULL�� �ƹ��͵� ó������ �ʴ� �����̴�.
--�ƹ��͵� ó������ �ʰ� ���� ��� NULL���� ����Ѵ�.

--NULL�� ��� ����
/*
IF VN_VARIABLE = 'A' THEN
    ó�� ����1;
ELSIF VN_VARIABLE = 'B' THEN
    ó�� ����2;
    ...
ELSE NULL;
END IF;

CASE WHEN VN_VARIABLE = 'A' THEN
            ó������1;
    WHEN VN_VARIABLE = 'B' THEN
            ó������2;
    ...
    ELSE NULL;
END CASE;
*/

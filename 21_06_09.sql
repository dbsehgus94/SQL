--�Լ� ����
--���� �����(4��) ����� SQL �Լ��� �ƴ� ����ڰ� ���� ������ �����ϴ� ����� ���� �Լ��� ���Ѵ�.
/*
CREATE OR REPLACE FUNCTION �Լ��̸� (�Ű�����1, �Ű�����2, ...)
RETURN ������Ÿ��;
IS[AS]
    ����, ��� �� ����
BEGIN
    �����
    
    RETURN ��ȯ��;
    [EXCEPTION
    ���� ó����]
END [�Լ� �̸�];
*/
--CREATE OR REPLACE FUNCTION : �Լ� ����
--���� �Լ��� ����� ���� ������ �ϴ��� �� ������ ����� ��� �������� �� �ְ� ���������� ������ �������� �ݿ��ȴ�.
--�Ű����� :  �Լ��� ���޵Ǵ� �Ű�������, "�Ű������� ������ Ÿ��" ���·� ����Ѵ�. �Ű������� ������ �� �ִ�.
--RETURN ������ Ÿ�� : �Լ��� ��ȯ�� ������ Ÿ���� �����Ѵ�.
--RETURN ��ȯ�� : �Ű������� �޾� Ư�� ������ ������ �� ��ȯ�� ���� ����Ѵ�.

--�������� ��ȯ�ϴ� MOD �Լ��� ����� ���� �Լ��� ����(my_mod)
CREATE OR REPLACE FUNCTION my_mod (num1 NUMBER, num2 NUMBER)
    RETURN NUMBER -- ��ȯ ������ Ÿ���� NUMBER
IS
    vn_remainder NUMBER := 0; -- ��ȯ�� ������
    vn_quotient NUMBER :=0; --��
BEGIN
    vn_quotient := FLOOR(num1/num2); -- ������/���� ������� ���� �κ��� �ɷ� ����
    vn_remainder := num1 - (num2 * vn_quotient); -- ������ = ������ - (���� * ��)
    
    RETURN vn_remainder; -- �������� ��ȯ
END;
/

--�Լ� ȣ��
/*
<�Ű������� ���� �Լ� ȣ��>
�Լ��� Ȥ�� �Լ���()

<�Ű������� �ִ� �Լ� ȣ��>
�Լ���(�Ű�����1, �Ű�����2, ...)
*/

--my_mod �Լ� ȣ��
SELECT my_mod(14, 3) reminder
FROM DUAL;

--����(countries) ���̺��� �о� ������ȣ�� �޾� �������� ��ȯ�ϴ� �Լ�
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
RETURN VARCHAR2 --�������� ��ȯ�ϹǷ� ��ȯ ������ Ÿ���� VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    
    RETURN vs_country_name; -- ������ ��ȯ
END;
/

--ȣ��
--������ȣ 52777�� ����ũ����, 10000 ��ȣ�� ���������� ���� ���̺� �������� �ʾ� NULL�� ��ȯ��.
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name (10000) COUN2
FROM DUAL;

--�ش� ������ ���� ��� NULL ��� '����'�̶�� ���ڿ��� ��ȯ�ϴ� �Լ��� ����
--�ʿ���� ������ �����ϱ� �ѵ� �ش� ������ �ִ��� üũ �ϱ� ���� ���� ���̺��� �� �� ��ȸ �߰�
--������ ������ �������� �������� ���� �� �� �� �� ��ȸ�� ���̴�.
--���� �̷��� �� �ʿ� ���� �� ���� ��ȸ�ؼ� ó���ص� �� �� ������, �̷��� ������ ������ ������ �����Ѵ�.
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
RETURN VARCHAR2 --�������� ��ȯ�ϹǷ� ��ȯ ������ Ÿ���� VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO vn_count
    FROM countries
    WHERE country_id = p_country_id;
    
    IF vn_count = 0 THEN
        vs_country_name := '�ش籹�� ����';
    ELSE
        SELECT country_name
        INTO vs_country_name
        FROM countries
        WHERE country_id = p_country_id;
    END IF;
    
    RETURN vs_country_name;
END;
/

--ȣ��
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name (10000) COUN2
FROM DUAL;

--�Ű����� ���� �Լ�(���� �α��� �� ����� �̸��� ��ȯ�ϴ� �Լ�)
CREATE OR REPLACE FUNCTION fn_get_user
    RETURN VARCHAR2 -- ��ȯ ������ Ÿ���� VARCHAR2
IS
    vs_user_name VARCHAR2(80);
BEGIN
    SELECT USER
    INTO vs_user_name
    FROM DUAL;
    
    RETURN vs_user_name; -- ����� �̸� ��ȯ
END;
/

--�Լ� ȣ��(�Ű������� ������ �Լ� �̸� ������ '()'�� �ٿ��� �ǰ� ���� �ȴ�.)
SELECT fn_get_user(), fn_get_user
FROM DUAL;

--���ν���(Ư���� ������ ó���ϱ⸸ �ϰ� ��� ���� ��ȯ������ �ʴ� ���� ���α׷�)
--���̺��� �����͸� ������ �Ը��� �°� �����ϰ� �� ����� �ٸ� ���̺� �ٽ� �����ϰų� �����ϴ� �Ϸ��� ó���� �Ҷ� �ַ� ���ν����� ����Ѵ�.

--���ν��� ����
--�Լ��� ���ν��� ��� DB�� ����� ��ü�̹Ƿ� ���ν����� ������(Stored, �����) ���ν������ �θ��⵵ �Ѵ�.
--��������
/*
CREATE OR REPLACE PROCEDURE ���ν��� �̸�
    (�Ű�������1 [IN |OUT| IN OUT] ������Ÿ��[:= ����Ʈ ��],
     �Ű�������2 [IN |OUT| IN OUT] ������Ÿ��[:= ����Ʈ ��],
     ...
     )
IS[AS]
    ����, ��� �� ����
BEGIN
    �����
    
[EXCEPTION
    ���� ó����]
END [���ν��� �̸�];
*/
--CREATE OR REPLACE PROCEDURE : �Լ��� ���������� �� ������ ����Ͽ� ���ν����� �����Ѵ�.
--�Ű����� : IN OUT�� �Է°� ����� ���ÿ� �Ѵٴ� �ǹ̴�. �ƹ� �͵� ������� ������ ����Ʈ�� IN �Ű��������� ���Ѵ�.
--OUT �Ű������� ���ν��� ������ ���� ó�� ��, �ش� �Ű������� ���� �Ҵ��� ���ν��� ȣ�� �κп��� �� ���� ������ �� �ִ�.
--IN �Ű��������� ����Ʈ �� ������ �����ϴ�.

--�ű� JOB�� �ִ� ���ν���
--������, ��������  �ý��� �������ڷ� ����� ���̹Ƿ� �Ű������� �� 4���� �޴´�.
CREATE OR REPLACE PROCEDURE my_new_job_proc
( p_job_id IN JOBS.JOB_ID%TYPE,
  p_job_title IN JOBS.JOB_TITLE%TYPE,
  p_min_sal IN JOBS.MIN_SALARY%TYPE,
  p_max_sal IN JOBS.MAX_SALARY%TYPE )
IS

BEGIN
    INSERT INTO JOBS (job_id, job_title, min_salary, max_salary, create_date, update_date)
    VALUES(p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
    COMMIT;
END;
/
--���ν��� ����(ȣ��)
--���ν����� ��ȯ ���� �����Ƿ� �Լ�ó�� SELECT ������ ����� �� ����
/*
<���ν��� ����1>
EXEC my new_jop_proc
*/

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);

--���� Ȯ���� ���� JOBS ���̺� ��ȸ
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';
--�� SELECT���� �õ��ϰ� �ٽ� ���ν����� �����ϸ� '���Ἲ ���� ���ǿ� ����' �޼����� ��µȴ�.
--������ JOBS ���̺��� JOB_ID�� PRIMARY KEY�� ���� �ִµ��� �ұ��ϰ� ������ JOB_ID(SM_JOB1)�� �� �Է��Ϸ��� �õ��߱� �����̴�.
--�⺻���� ������ ���Ἲ ������ ����Ŭ���� �ڵ����� �ɷ��ش�.
--����Ŭ���� ���� ó���� �ñ� ���� �ƴ϶�, ������ JOB_ID�� ������ �ű� INSERT ��� �ٸ� ������ �����ϵ��� �ϴ� ���ν����� �����غ��ڴ�.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PROC
( P_JOB_ID IN JOBS.JOB_ID%TYPE,
  P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
  P_MIN_SAL IN JOBS.MIN_SALARY%TYPE,
  P_MAX_SAL IN JOBS.MAX_SALARY%TYPE)
IS
  VN_CNT NUMBER := 0;
BEGIN
    -- ������ JOB_ID�� �ִ� �� üũ
    SELECT COUNT(*)
    INTO VN_CNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    -- ������ INSERT
    IF VN_CNT = 0 THEN
        INSERT INTO JOBS ( JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY,
                                        CREATE_DATE, UPDATE_DATE)
                            VALUES( P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL,
                                        SYSDATE, SYSDATE);
    ELSE -- ������ UPDATE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
        MIN_SALARY = P_MIN_SAL,
        MAX_SALARY = P_MAX_SAL,
        UPDATE_DATE = SYSDATE
        WHERE JOB_ID = P_JOB_ID;
    END IF;
    COMMIT;
END;
/

--�ٽ� ����, �ּ� �޿���, �ִ� �޿��� �����Ͽ� �Է�
--������ JOB_ID ���� �Է��ߴ��� INSERT�� ���� �ʰ� �Ű������� ���޵� �ٸ� ������ UPDATE������ Ȯ���� �� �ִ�.
EXEC MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000);

SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--���ν����� �Ű������� ������ ������ �� �Ű����� ���� ������ ������ ȥ���� ������ �ſ� ����.
--�׷� ��쿡�� �Ʒ� ���ÿ� ���� �Ű������� �Է� ���� ������ �����ϸ� �ſ� ���ϴ�.
/*
<���ν��� ����2>
EXEC Ȥ�� EXECUTE ���ν�����(�Ű�����1 => �ް�����1 ��,
                                                �Ű�����2 => �Ű�����2 ��, ...);
*/

-- '=>' ��ȣ�� ����� �ش� �Ű�������� ���� �����ϴ� ���·� ������ �� �ִ�. MY_NEW_JOB_PROC ���ν����� �� ���·� �����غ��ڴ�.
EXECUTE MY_NEW_JOB_PROC ( P_JOB_ID => 'SM_JOB1', P_JOB_TITLE => 'Sample JOB1', P_MIN_SAL => 2000, P_MAX_SAL => 7000);
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--�Ű����� ����Ʈ �� ����
--���ν����� ������ ���� �ݵ�� �Ű������� ������ ���� ���� ������ �����ؾ� �Ѵ�. ���� �Ű����� ���� �����ϸ� ������ ���� ������ �߻��Ѵ�.
--'MY_NEW_JOB_PROC' ȣ�� �� �μ��� ������ ������ �߸��Ǿ����ϴ�.
EXECUTE MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1');

--���ν����� �Ű������� ����Ʈ ���� �����ϸ� ������ �� �ش� �Ű������� �������� �ʴ���� ������ ���� �ʰ� ����Ʈ�� ������ ���� �ش� �Ű������� ����ȴ�.
--MY_NEW_JOB_PROC ���ν����� �ּ�, �ִ� �޿��� ����Ʈ ���� ���� 10�� 100���� ���� ������ ���ڴ�.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PROC
(P_JOB_ID IN JOBS.JOB_ID%TYPE,
 P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
 P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 10, --����Ʈ �� ����
 P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 100) -- ����Ʈ �� ����
IS
  VN_CNT NUMBER := 0;
BEGIN
    -- ������ JOB_ID�� �ִ� �� üũ
    SELECT COUNT(*)
    INTO VN_CNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    -- ������ INSERT
    IF VN_CNT = 0 THEN
        INSERT INTO JOBS ( JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY,
                                        CREATE_DATE, UPDATE_DATE)
                            VALUES( P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL,
                                        SYSDATE, SYSDATE);
    ELSE -- ������ UPDATE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
        MIN_SALARY = P_MIN_SAL,
        MAX_SALARY = P_MAX_SAL,
        UPDATE_DATE = SYSDATE
        WHERE JOB_ID = P_JOB_ID;
    END IF;
    COMMIT;
END;
/

--JOB_ID�� JOB_TITLE ���� ������ ���ν��� ����
--�ּ�, �ִ� �޿� �Ű������� �������� �ʾҾ ����Ʈ ���� �����ϸ� �� ���� �Ű� ���� ���Ҵ�Ǿ� ó���Ǿ����� �� �� �ִ�.
--�� ���� ������ ���� ����Ʈ ���� IN �Ű��������� ����� �� �ִ�.
EXECUTE MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1');
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--OUT, IN OUT �Ű�����
--���ν����� �Լ��� ���� ū �������� ��ȯ ���� ���� ���δ�.
--���ν����� ���� ��ȯ ���� ������ OUT �Ű������� ���� ���� ��ȯ�� �� �ִ�.
--OUT �Ű������� ���ν��� ���� ������ OUT �Ű������� ���� ���·� �����ϰ�, ���ν��� ����ο��� �� �Ű������� Ư�� ���� �Ҵ��Ѵ�.
--������ ������ ������ ������ ������ ���� ������ �� �ִ� ���̴�.
--���ν��� ���� �� �Ű�������� ������ Ÿ�Ը� ����ϸ� ����Ʈ�� IN �Ű������� ������ OUT �Ű������� �ݵ�� OUT Ű���带 ����ؾ��Ѵ�.

--MY_NEW_JOB_PROC���� �������ڸ� �޴� OUT �Ű������� �߰��� ���ڴ�.
--���� JOBS ���̺��� CREATE_DATE, UPDATE_DATE �÷� ������ SYSDATE�� ���� �Է�������
--�̹����� VN_CUR_DATE ������ ������ SYSDATE�� �ʱ�ȭ�� ��, �� ������ ����ߴ�.
--�̷��� ó���� ������ SYSDATE�� �� ������ ���� �ٲ�Ƿ� JOBS ���̺� �Էµǰų� ���ŵ� ���� ���� ��Ȯ�� �������� ���ؼ���.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PROC
(P_JOB_ID IN JOBS.JOB_ID%TYPE,
 P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
 P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 10,
 P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 100,
 P_UPD_DATE OUT JOBS.UPDATE_DATE%TYPE)
IS
 VN_CNT NUMBER := 0;
 VN_CUR_DATE JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN

 -- ������ JOB_ID�� �ִ��� üũ
 SELECT COUNT(*)
 INTO VN_CNT
 FROM JOBS
 WHERE JOB_ID = P_JOB_ID;
 
 -- ������ INSERT
 IF VN_CNT = 0 THEN
    INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY, CREATE_DATE, UPDATE_DATE)
                        VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL, VN_CUR_DATE, VN_CUR_DATE);
 ELSE -- ������ UPDATE
    UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
                MIN_SALARY = P_MIN_SAL,
                MAX_SALARY = P_MAX_SAL,
                UPDATE_DATE = VN_CUR_DATE
        WHERE JOB_ID = P_JOB_ID;
    END IF;
    
    -- OUT �Ű������� ���� �Ҵ�
    P_UPD_DATE := VN_CUR_DATE;
    
    COMMIT;
END;
/

--���ν����� �����ϰ� OUT �Ű����� ���� �����ؾ� �ϴµ�, �̶� ������ ������ �����ؼ� �Ű������� ������ �� ���� �����ؾ� �Ѵ�.
--������ �ʿ��ϹǷ� �� ���ν����� �����ϴ� �͸� ����� ����� ���ڴ�.
--"MY_NEW_JOB_PROC"�� �������ϴ� ���� �� �ϳ��� ���� ��: ��� ������ �߻��ߴ�.
--�͸� ��Ͽ��� ���ν����� �����ϸ� EXEC�� EXECUTE�� ������ �ʴ´�.
DECLARE
    VD_CUR_DATE JOBS.UPDATE_DATE%TYPE;
BEGIN
    EXEC MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000, VD_CUR_DATE);
    
    DBMS_OUTPUT.PUT_LINE(VD_CUR_DATE);
END;
/

--EXEC, EXECUTE�� �����ϰ� ����
DECLARE
    VD_CUR_DATE JOBS.UPDATE_DATE%TYPE;
BEGIN
    MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000, VD_CUR_DATE);
    
    DBMS_OUTPUT.PUT_LINE(VD_CUR_DATE);
END;
/

--IN OUT �Ű�����(�Է°� ����� ���ÿ� ����� �� �ִ�.)
--���ν��� ���� �� OUT �Ű������� ������ ������ ���� �Ҵ��ؼ� �Ѱ��� �� ������ ū �ǹ̴� ���� ���̴�.
--OUT �Ű������� �ش� ���ν����� ���������� ������ �Ϸ��� ������ ���� �Ҵ���� �ʴ´�.
--���� �Ű������� ���� �����ؼ� ����� ���� �ٽ� �� �Ű������� ���� �޾ƿ� �����ϰ� �ʹٸ� IN OUT �Ű������� ����ؾ��Ѵ�.

--������ IN OUT ����
CREATE OR REPLACE PROCEDURE my_parameter_test_proc (
                    P_VAR1  VARCHAR2,
                    P_VAR2 OUT VARCHAR2,
                    P_VAR3 IN OUT VARCHAR2)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('P_VAR1 VALUE = ' || P_VAR1);
    DBMS_OUTPUT.PUT_LINE('P_VAR2 VALUE = ' || P_VAR2);
    DBMS_OUTPUT.PUT_LINE('P_VAR3 VALUE = ' || P_VAR3);
    
    P_VAR2 := 'B2';
    P_VAR3 := 'C2';
END;
/

--���ν��� ����
--P_VAR�� ���۵Ǵ� ����� MY_PARAMETER_TEST_PROC ���ο��� ����� ���̰�, V_VAR�� ���۵Ǵ� ����� �� ���ν����� ������ �͸� ��Ͽ��� ����� ���̴�.
--OUT �Ű������� P_VAR2 �ڸ��� V_VAR2 ������ �־� 'B'��� ���� �Ѱ� �������� �ұ��ϰ� �ƹ��� ���� ������ Ȯ���� �� �ִ�.
--�̿� ���� IN OUT �Ű������� P_VAR3���� 'C'�� ���� �Ѱ� �༭ MY_PARAMETER_TEST_PROC ���ο��� �� ���� �޾� ����߰�
--�ٽ� 'C2'�� ���� �Ҵ��ؼ� ���������� V_VAR3 ���� 'C2'�� �� ���̴�.
DECLARE
    V_VAR1 VARCHAR2(10) := 'A';
    V_VAR2 VARCHAR2(10) := 'B';
    V_VAR3 VARCHAR2(10) := 'C';
BEGIN
    MY_PARAMETER_TEST_PROC (V_VAR1, V_VAR2, V_VAR3);
    
    DBMS_OUTPUT.PUT_LINE('V_VAR2 VALUE = ' || V_VAR2);
    DBMS_OUTPUT.PUT_LINE('V_VAR3 VALUE = ' || V_VAR3);
END;
/

--IN, OUT, IN OUT ����
--IN �Ű������� ������ �����ϸ� ���� �Ҵ��� �� ����.
--OUT �Ű������� ���� ������ ���� ������ �ǹ̰� ����.
--OUT, IN OUT �Ű��������� ����Ʈ ���� ������ �� ����.
--IN �Ű��������� ������ ���, �� ������ ������ ���� ���� ������ �� ������, 
--OUT, IN OUT �Ű������� ������ ���� �ݵ�� ���� ���·� ���� �Ѱ���� �Ѵ�.

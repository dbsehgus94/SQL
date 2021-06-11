/*
2��
SQL �Լ� �� INITCAP�̶� �Լ��� �ִ�. �� �Լ��� �Ű������� ������ ���ڿ����� �� ���ڸ� �빮�ڷ� ��ȯ�ϴ� �Լ���.
INITCAP�� �Ȱ��� �����ϴ� my_initcap�̶� �̸����� �Լ��� ������.
(��, ���⼭�� ���� �� ���ڷ� �ܾ� ���̸� �����Ѵٰ� �����Ѵ�)
*/ 

CREATE OR REPLACE FUNCTION my_initcap (ps_string VARCHAR2)
    RETURN VARCHAR2
IS
    VN_POS1 NUMBER := 1; --�� �ܾ� ���� ��ġ
    VS_TEMP VARCHAR2(100) := ps_string;
    VS_RETURN VARCHAR2(80); --��ȯ�� �빮�ڷ� ��ȯ�� ���ڿ� ����
    VN_LEN NUMBER;
BEGIN

    WHILE VN_POS1 <> 0 --���鹮�ڸ� �߰����� ���� ������ ������ ����.
    LOOP
        --���鹮���� ��ġ�� �����´�.
        VN_POS1 := INSTR(VS_TEMP, ' ');
            IF VN_POS1 = 0 THEN -- ���鹮�ڸ� �߰����� ������ ���, �� �� ������ �ܾ��� ���...
                VS_RETURN := VS_RETURN || UPPER(SUBSTR(VS_TEMP, 1, 1)) ||SUBSTR(VS_TEMP, 2, VN_LEN -1);
                
            ELSE -- ���鹮�� ��ġ�� ��������, �� ù �ڴ� UPPER�� ����� �빮�ڷ� ��ȯ�ϰ�, ������ ���ڴ� �߶� ������ �ִ´�.
                VS_RETURN := VS_RETURN || UPPER(SUBSTR(VS_TEMP, 1, 1)) ||SUBSTR(VS_TEMP, 2, VN_POS1 -2) || ' ';
                
            END IF;
            
        VN_LEN := LENGTH(VS_TEMP);
        -- VS_TEMP ������ ���� ��ü ���ڿ��� ������, ������ ���鼭 �� �ܾ ���ʷ� ���ش�.
        VS_TEMP := SUBSTR(VS_TEMP, VN_POS1+1, VN_LEN - VN_POS1);
        
        -- VS_TEMP := SUBSTR('birthday to you', VN_POS+1, VN_LEN-6);
    
    END LOOP;
    RETURN VS_RETURN;
    COMMIT;
   
END;
/

SELECT my_initcap('happy birthday to you dear my friend') "edited string" FROM DUAL;

/*
3��
��¥�� SQL �Լ� �߿��� �ش� �� ������ ���ڸ� ��ȯ�ϴ� LAST_DAY�� �Լ��� �ִ�. �Ű������� ���������� ��¥�� �޾�,
�ش� ��¥�� �� ������ ��¥�� ���������� ��ȯ�ϴ� �Լ��� my_last_day�� �̸����� ����� ���ڴ�.
*/
CREATE OR REPLACE FUNCTION my_last_day (ps_input_date VARCHAR2)
    RETURN VARCHAR2
    
IS
    VS_INPUT_DATE VARCHAR(10) := ps_input_date;
    VS_YEAR VARCHAR2(4);
    VS_MONTH VARCHAR2(2);
    VS_RETURN_DATE VARCHAR2(50);
    
BEGIN
    VS_INPUT_DATE := REPLACE(VS_INPUT_DATE, '-', '');
    IF LENGTH(VS_INPUT_DATE) <> 8 THEN 
    VS_RETURN_DATE := '��¥�� �߸� �Է��ϼ̽��ϴ�.';
    END IF;
    
    VS_YEAR := SUBSTR(VS_INPUT_DATE, 1, 4);
    VS_MONTH := SUBSTR(VS_INPUT_DATE, 5, 2) ;
    
    IF VS_MONTH = 12 THEN
    /*
    VS_MONTH := '01';
    VS_RETURN_DATE := TO_CHAR(TO_DATE(VS_YEAR +1 || VS_MONTH || '01', 'YYYY-MM-DD') -1, 'YYYYMMDD');
    */
    --VS_RETURN_DATE := TO_CHAR(TO_DATE(VS_YEAR +1 || VS_MONTH - 11 || '01', 'YYYY-MM-DD') -1, 'YYYYMMDD');
    --VS_RETURN_DATE := TO_CHAR(TO_DATE(VS_YEAR +1 || '01' || '01', 'YYYY-MM-DD') -1, 'YYYYMMDD');
    VS_RETURN_DATE := TO_CHAR(TO_DATE(VS_YEAR || VS_MONTH || '31', 'YYYY-MM-DD'), 'YYYYMMDD');
    
    ELSE
    VS_MONTH := TRIM(TO_CHAR(TO_NUMBER(VS_MONTH) +1, '00'));
    VS_RETURN_DATE := TO_CHAR(TO_DATE(VS_YEAR || VS_MONTH || '01', 'YYYY-MM-DD') -1, 'YYYYMMDD');
    
    END IF;
    
    RETURN VS_RETURN_DATE;
    
    COMMIT;
END;
/    

SELECT my_last_day('2021-11-11') last_day
FROM DUAL;
SELECT my_last_day('2016-12-25') last_day
FROM DUAL;
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

/*
7�忡�� ����� �μ��� ������ ������ �� ���̺� �μ��� ���� ������ �ִ� my_hier_dept_proc��� ���ν����� �ۼ��϶�.
--�Ű������� ����, ���ν����� �����ϸ� �� ���̺� �ִ� ���� �����͸� �����ϰ� �ٽ� �ִ� ���·� ����� ���ڴ�.
*/

CREATE TABLE ch09_dept (
        DEPARTMENT_ID   NUMBER,
        DEPARTMENT_NAME VARCHAR2(100),
        LEVELS  NUMBER );
        
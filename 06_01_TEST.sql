SELECT PHONE_NUMBER,
LPAD(SUBSTR(PHONE_NUMBER, 5), 13, '(031)'),
REPLACE(LPAD(SUBSTR(PHONE_NUMBER, 5), 13, '(031)'), '.', '-')
FROM EMPLOYEES;

SELECT EMPLOYEE_ID AS �����ȣ, EMP_NAME AS �����, HIRE_DATE AS �Ի�����, (TO_CHAR(SYSDATE, 'YYYY')-TO_CHAR(HIRE_DATE, 'YYYY')) AS �ټӳ��
FROM EMPLOYEES
WHERE (TO_CHAR(SYSDATE, 'YYYY')-TO_CHAR(HIRE_DATE, 'YYYY')) >= 22
ORDER BY (TO_CHAR(SYSDATE, 'YYYY')-TO_CHAR(HIRE_DATE, 'YYYY')) ASC;

SELECT CUST_NAME, CUST_MAIN_PHONE_NUMBER,
TRANSLATE(CUST_MAIN_PHONE_NUMBER, '0123456789', 'imastudent')
FROM CUSTOMERS
ORDER BY CUST_NAME;

CREATE TABLE exam3 (
    name    VARCHAR2(100),
    new_phone_number    VARCHAR2(25)
);

INSERT INTO exam3 (name, new_phone_number)
SELECT CUST_NAME,
TRANSLATE(CUST_MAIN_PHONE_NUMBER, '0123456789', 'imastudent')
FROM CUSTOMERS;

SELECT name, new_phone_number,
TRANSLATE(new_phone_number, 'imastudent', '0123456789')
FROM exam3;
drop table exam3;

SELECT CUST_YEAR_OF_BIRTH,
DECODE (TRUNC((CUST_YEAR_OF_BIRTH - 1900)/10), '5', '1950���',
                                        '6', '1960���',
                                        '7', '1970���',
                                        '8', '1980���',
                                        '9', '1990���',
                                        '��Ÿ') as ����                                    
FROM CUSTOMERS;   

SELECT TO_CHAR(HIRE_DATE, 'MM') AS �Ի��,
COUNT(*)
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'MM')
ORDER BY TO_CHAR(HIRE_DATE, 'MM');

SELECT PERIOD, REGION, SUM(LOAN_JAN_AMT)
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2011%'
GROUP BY PERIOD, REGION
ORDER BY PERIOD, REGION;

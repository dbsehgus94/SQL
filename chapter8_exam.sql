--1번. 구구단 중 3단을 출력하는 익명 블록을 만들어 보자.
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
--2번. 사원 테이블에서 201번 사원의 이름과 이메일 주소를 출력하는 익명 블록을 만들어 보자.
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
-- 3번. 사원 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤, 이 '번호+1'번으로 아래의 사원을 사원 테이블에 신규 입력하는 익명 블록을 만들어 보자.
/*
<사원명> : Harrison Ford
<이메일> : HARRIS
<입사일자> : 현재일자
<부서번호> : 50
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
                            
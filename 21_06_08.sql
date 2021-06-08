--IF문

/*
<조건이 1개인 경우>
IF 조건 THEN
    조건처리;
END IF;

<조건이 N개인 경우>
IF 조건 THEN
    조건처리 1;
ELSIF 조건2 THEN
    조건처리 2;
...
ELSE
    조건처리N;
END IF
*/
--vn_num2가 vn_num1보다 크므로 else부분으로 제어가 넘어가 실행된 것을 확인할 수 있다.
DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '이 큰수');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '이 큰수');
    END IF;
END;
/

--앞의 익명 블록은 샘플 데이터를 생성할 때 사용했던 DBMS_RANDOM 패키지를 사용하여 10부터 120까지 숫자를 생성한 후
--10의 자리(-1)에서 ROUND 처리를 해서 실행할 때마다 무작위로 10~120까지의 수를 vn_department_id 변수에 할당한다.
--이 변수 값에 해당하는 부서번호를 가진 사원을 무작위로 1명 선택해 급여를 가져와 vn_salary 변수에 넣어
--IF 문을 사용하여 범위에 맞게 출력하는 로직이다.
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
        DBMS_OUTPUT.PUT_LINE('낮음');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('중간');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('최상위');
    END IF;
END;
/
--IF 문 중첩
--익명블록은 사원 테이블에서 커미션까지 가져와 커미션이 0보다 클 경우
--다시 조건을 걸어 커미션이 0.15보다 크면 '급여*커미션' 결과를 출력하고
--커미션이 0보다 작으면 급여만 출력하게 설정하였다.
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

--CASE문
/*
<유형 1>
CASE 표현식
    WHEN 결과1 THEN
        처리문1;
    WHEN 결과2 THEN
        처리문2;
    ...
    ELSE
        기타 처리문;

<유형 2>
CASE WHEN 표현식1 THEN
        처리문1;
     WHEN 표현식2 THEN
        처리문2;
     ...
     ELSE
        기타 처리문;
END CASE;
*/
--급여에 따라 '높음', '낮음'을 출력하는 IF문을 CASE문으로 변환
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
            DBMS_OUTPUT.PUT_LINE('낮음');
         WHEN VN_SALARY BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
         WHEN VN_SALARY BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
         ELSE
            DBMS_OUTPUT.PUT_LINE('최상위');
    END CASE;
END;
/

--LOOP문(반복문)
/*
LOOP
    처리문;
    EXIT [WHEN 조건]
END LOOP;
*/

--구구단 3단(LOOP)
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '= ' || VN_BASE_NUM * VN_CNT);
        VN_CNT := VN_CNT + 1; -- LOOP를 돌면서 VN_CNT 값은 1씩 증가됨
        EXIT WHEN VN_CNT >9; -- VN_CNT가 9보다 크면 LOOP 종료
    END LOOP;
END;
/

--WHILE문
/*
WHILE 조건
LOOP
    처리문;
END LOOP;
*/

--구구단 3단(WHILE)
--LOOP문은 루프를 빠져 나가는 조건을 주었지만, WHILE문에서는 루프를 수행하는 조건을 준다.
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
WHILE VN_CNT <=9 -- VN_CNT가 9보다 작거나 같을 때만 반복 처리
LOOP
    DBMS_OUTPUT.PUT_LINE (VN_BASE_NUM || '*' || VN_CNT ||'= '||VN_BASE_NUM * VN_CNT);
    VN_CNT := VN_CNT + 1; -- VN_CNT 값을 1씩 증가
END LOOP;
END;
/
--구구단(WHILE문, *5까지 표시)
DECLARE
    VN_BASE_NUM NUMBER := 3;
    VN_CNT NUMBER := 1;
BEGIN
WHILE VN_CNT <=9 -- VN_CNT가 9보다 작거나 같을 때만 반복 처리
LOOP
    DBMS_OUTPUT.PUT_LINE (VN_BASE_NUM || '*' || VN_CNT ||'= '||VN_BASE_NUM * VN_CNT);
    EXIT WHEN VN_CNT =5; -- VN_CNT 값이 5가 되면 루프 종료
    VN_CNT := VN_CNT + 1; -- VN_CNT 값을 1씩 증가
END LOOP;
END;
/

--FOR문
/*
FOR 인덱스 IN [REVERSE] 초깃값..최종값
LOOP
    처리문;
END LOOP;
*/

--구구단 3단(FOR문)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR I IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
    END LOOP;
END;
/

--구구단 3단(FOR문, REVERSE 사용)
DECLARE
    VN_BASE_NUM NUMBER := 3;
BEGIN
    FOR I IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || I ||'= '||VN_BASE_NUM * I);
    END LOOP;
END;
/

--CONTINUE문
--반복문 내에서 특정 조건에 부합할 때 처리 로직을 건너뛰고 상단의 루프 조건으로 건너가
--루프를 계속 수행할 때 사용한다.
--EXIT는 루프를 완전히 빠져나오지만, CONTINUE는 제어 범위가 조건절로 넘어간다.

--구구단 3단(FOR문, CONTINUE문, *5만 빼고 출력)
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

--GOTO문
--GOTO문을 만나면 GOTO문이 지정하는 라벨로 제어가 넘어간다.
--중간중간 GOTO문을 사용해 제어를 다른 부분으로 넘기면 로직의 일관성이 훼손되기 때문에
--GOTO문을 잘 사용하지 않는다.

--구구단 3단(FOR문, GOTO문)
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

--NULL문
--NULL은 아무것도 처리하지 않는 문장이다.
--아무것도 처리하지 않고 싶은 경우 NULL문을 사용한다.

--NULL문 사용 예시
/*
IF VN_VARIABLE = 'A' THEN
    처리 로직1;
ELSIF VN_VARIABLE = 'B' THEN
    처리 로직2;
    ...
ELSE NULL;
END IF;

CASE WHEN VN_VARIABLE = 'A' THEN
            처리로직1;
    WHEN VN_VARIABLE = 'B' THEN
            처리로직2;
    ...
    ELSE NULL;
END CASE;
*/

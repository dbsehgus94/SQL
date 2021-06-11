/*
2번
SQL 함수 중 INITCAP이란 함수가 있다. 이 함수는 매개변수로 전달한 문자열에서 앞 글자만 대문자로 변환하는 함수다.
INITCAP과 똑같이 동작하는 my_initcap이란 이름으로 함수를 만들어보자.
(단, 여기서는 공백 한 글자로 단어 사이를 구분한다고 가정한다)
*/ 

CREATE OR REPLACE FUNCTION my_initcap (ps_string VARCHAR2)
    RETURN VARCHAR2
IS
    VN_POS1 NUMBER := 1; --각 단어 시작 위치
    VS_TEMP VARCHAR2(100) := ps_string;
    VS_RETURN VARCHAR2(80); --반환할 대문자로 변환된 문자열 변수
    VN_LEN NUMBER;
BEGIN

    WHILE VN_POS1 <> 0 --공백문자를 발견하지 못할 때까지 루프를 돈다.
    LOOP
        --공백문자의 위치를 가져온다.
        VN_POS1 := INSTR(VS_TEMP, ' ');
            IF VN_POS1 = 0 THEN -- 공백문자를 발견하지 못했을 경우, 즉 맨 마지막 단어일 경우...
                VS_RETURN := VS_RETURN || UPPER(SUBSTR(VS_TEMP, 1, 1)) ||SUBSTR(VS_TEMP, 2, VN_LEN -1);
                
            ELSE -- 공백문자 위치를 기준으로, 맨 첫 자는 UPPER를 사용해 대문자로 변환하고, 나머지 문자는 잘라서 변수에 넣는다.
                VS_RETURN := VS_RETURN || UPPER(SUBSTR(VS_TEMP, 1, 1)) ||SUBSTR(VS_TEMP, 2, VN_POS1 -2) || ' ';
                
            END IF;
            
        VN_LEN := LENGTH(VS_TEMP);
        -- VS_TEMP 변수는 최초 전체 문자열이 들어오며, 루프를 돌면서 한 단어씩 차례로 없앤다.
        VS_TEMP := SUBSTR(VS_TEMP, VN_POS1+1, VN_LEN - VN_POS1);
        
        -- VS_TEMP := SUBSTR('birthday to you', VN_POS+1, VN_LEN-6);
    
    END LOOP;
    RETURN VS_RETURN;
    COMMIT;
   
END;
/

SELECT my_initcap('happy birthday to you dear my friend') "edited string" FROM DUAL;

/*
3번
날짜형 SQL 함수 중에는 해당 월 마지막 일자를 반환하는 LAST_DAY란 함수가 있다. 매개변수로 문자형으로 날짜를 받아,
해당 날짜의 월 마지막 날짜를 문자형으로 반환하는 함수를 my_last_day란 이름으로 만들어 보겠다.
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
    VS_RETURN_DATE := '날짜를 잘못 입력하셨습니다.';
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
7장에서 배웠던 부서별 계층형 쿼리로 위 테이블에 부서별 계층 정보를 넣는 my_hier_dept_proc라는 프로시저를 작성하라.
--매개변수는 없고, 프로시저를 실행하면 위 테이블에 있는 기존 데이터를 삭제하고 다시 넣는 형태로 만들어 보겠다.
*/

CREATE TABLE ch09_dept (
        DEPARTMENT_ID   NUMBER,
        DEPARTMENT_NAME VARCHAR2(100),
        LEVELS  NUMBER );
        
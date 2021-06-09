--함수 생성
--전에 배웠던(4장) 내장된 SQL 함수가 아닌 사용자가 직접 로직을 구현하는 사용자 정의 함수를 말한다.
/*
CREATE OR REPLACE FUNCTION 함수이름 (매개변수1, 매개변수2, ...)
RETURN 데이터타입;
IS[AS]
    변수, 상수 등 선언
BEGIN
    실행부
    
    RETURN 반환값;
    [EXCEPTION
    예외 처리부]
END [함수 이름];
*/
--CREATE OR REPLACE FUNCTION : 함수 생성
--최초 함수를 만들고 나서 수정을 하더라도 이 구문을 사용해 계속 컴파일할 수 있고 마지막으로 수정된 최종본이 반영된다.
--매개변수 :  함수로 전달되는 매개변수로, "매개변수명 데이터 타입" 형태로 명시한다. 매개변수는 생략할 수 있다.
--RETURN 데이터 타입 : 함수가 반환할 데이터 타입을 지정한다.
--RETURN 반환값 : 매개변수를 받아 특정 연산을 수행한 후 반환할 값을 명시한다.

--나머지를 반환하는 MOD 함수를 사용자 정의 함수로 구현(my_mod)
CREATE OR REPLACE FUNCTION my_mod (num1 NUMBER, num2 NUMBER)
    RETURN NUMBER -- 반환 테이터 타입은 NUMBER
IS
    vn_remainder NUMBER := 0; -- 반환할 나머지
    vn_quotient NUMBER :=0; --몫
BEGIN
    vn_quotient := FLOOR(num1/num2); -- 피젯수/젯수 결과에서 정수 부분을 걸러 낸다
    vn_remainder := num1 - (num2 * vn_quotient); -- 나머지 = 피젯수 - (젯수 * 몫)
    
    RETURN vn_remainder; -- 나머지를 반환
END;
/

--함수 호출
/*
<매개변수가 없는 함수 호출>
함수명 혹은 함수명()

<매개변수가 있는 함수 호출>
함수명(매개변수1, 매개변수2, ...)
*/

--my_mod 함수 호출
SELECT my_mod(14, 3) reminder
FROM DUAL;

--국가(countries) 테이블을 읽어 국가번호를 받아 국가명을 반환하는 함수
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
RETURN VARCHAR2 --국가명을 반환하므로 반환 데이터 타입은 VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT country_name
    INTO vs_country_name
    FROM countries
    WHERE country_id = p_country_id;
    
    RETURN vs_country_name; -- 국가명 반환
END;
/

--호출
--국가번호 52777는 덴마크지만, 10000 번호를 가진국가는 국가 테이블에 존재하지 않아 NULL이 반환됨.
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name (10000) COUN2
FROM DUAL;

--해당 국가가 없는 경우 NULL 대신 '없음'이라는 문자열을 반환하는 함수를 지정
--필요없는 로직이 존재하긴 한데 해당 국가가 있는지 체크 하기 위해 국가 테이블을 한 번 조회 했고
--국가가 있으면 국가명을 가져오기 위해 또 한 번 더 조회한 것이다.
--굳이 이렇게 할 필요 없이 한 번만 조회해서 처리해도 될 것 같은데, 이렇게 실행한 이유는 다음에 설명한다.
CREATE OR REPLACE FUNCTION fn_get_country_name (p_country_id NUMBER)
RETURN VARCHAR2 --국가명을 반환하므로 반환 데이터 타입은 VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO vn_count
    FROM countries
    WHERE country_id = p_country_id;
    
    IF vn_count = 0 THEN
        vs_country_name := '해당국가 없음';
    ELSE
        SELECT country_name
        INTO vs_country_name
        FROM countries
        WHERE country_id = p_country_id;
    END IF;
    
    RETURN vs_country_name;
END;
/

--호출
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name (10000) COUN2
FROM DUAL;

--매개변수 없는 함수(현재 로그인 한 사용자 이름을 반환하는 함수)
CREATE OR REPLACE FUNCTION fn_get_user
    RETURN VARCHAR2 -- 반환 데이터 타입은 VARCHAR2
IS
    vs_user_name VARCHAR2(80);
BEGIN
    SELECT USER
    INTO vs_user_name
    FROM DUAL;
    
    RETURN vs_user_name; -- 사용자 이름 반환
END;
/

--함수 호출(매개변수가 없으면 함수 이름 다음에 '()'를 붙여도 되고 빼도 된다.)
SELECT fn_get_user(), fn_get_user
FROM DUAL;

--프로시저(특정한 로직을 처리하기만 하고 결과 값을 반환하지는 않는 서브 프로그램)
--테이블에서 데이터를 추출해 입맛에 맞게 조작하고 그 결과를 다른 테이블에 다시 저장하거나 갱신하는 일련의 처리를 할때 주로 프로시저를 사용한다.

--프로시저 생성
--함수나 프로시저 모두 DB에 저장된 객체이므로 프로시저를 스토어드(Stored, 저장된) 프로시저라고 부르기도 한다.
--생성구문
/*
CREATE OR REPLACE PROCEDURE 프로시저 이름
    (매개변수명1 [IN |OUT| IN OUT] 데이터타입[:= 디폴트 값],
     매개변수명2 [IN |OUT| IN OUT] 데이터타입[:= 디폴트 값],
     ...
     )
IS[AS]
    변수, 상수 등 선언
BEGIN
    실행부
    
[EXCEPTION
    예외 처리부]
END [프로시저 이름];
*/
--CREATE OR REPLACE PROCEDURE : 함수와 마찬가지로 위 구문을 사용하여 프로시저를 생성한다.
--매개변수 : IN OUT은 입력과 출력을 동시에 한다는 의미다. 아무 것도 명시하지 않으면 디폴트로 IN 매개변수임을 뜻한다.
--OUT 매개변수는 프로시저 내에서 로직 처리 후, 해당 매개변수에 값을 할당해 프로시저 호출 부분에서 이 값을 참조할 수 있다.
--IN 매개변수에는 디폴트 값 설정이 가능하다.

--신규 JOB을 넣는 프로시저
--생성일, 갱신일은  시스템 현재일자로 등록할 것이므로 매개변수는 총 4개를 받는다.
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
--프로시저 실행(호출)
--프로시저는 반환 값이 없으므로 함수처럼 SELECT 절에는 사용할 수 없다
/*
<프로시저 실행1>
EXEC my new_jop_proc
*/

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);

--실행 확인을 위한 JOBS 테이블 조회
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';
--위 SELECT분을 시도하고 다시 프로시저를 실행하면 '무결성 제약 조건에 위배' 메세지가 출력된다.
--원인은 JOBS 테이블의 JOB_ID는 PRIMARY KEY로 잡혀 있는데도 불구하고 동일한 JOB_ID(SM_JOB1)를 또 입력하려고 시도했기 때문이다.
--기본적인 데이터 무결성 문제는 오라클에서 자동으로 걸러준다.
--오라클에게 오류 처리를 맡길 것이 아니라, 동일한 JOB_ID가 들어오면 신규 INSERT 대신 다른 정보를 갱신하도록 하는 프로시저를 수정해보겠다.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PROC
( P_JOB_ID IN JOBS.JOB_ID%TYPE,
  P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
  P_MIN_SAL IN JOBS.MIN_SALARY%TYPE,
  P_MAX_SAL IN JOBS.MAX_SALARY%TYPE)
IS
  VN_CNT NUMBER := 0;
BEGIN
    -- 동일한 JOB_ID가 있는 지 체크
    SELECT COUNT(*)
    INTO VN_CNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    -- 없으면 INSERT
    IF VN_CNT = 0 THEN
        INSERT INTO JOBS ( JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY,
                                        CREATE_DATE, UPDATE_DATE)
                            VALUES( P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL,
                                        SYSDATE, SYSDATE);
    ELSE -- 있으면 UPDATE
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

--다시 실행, 최소 급여값, 최대 급여값 수정하여 입력
--동일한 JOB_ID 값을 입력했더니 INSERT를 하지 않고 매개변수를 전달된 다른 정보를 UPDATE했음을 확인할 수 있다.
EXEC MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000);

SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--프로시저의 매개변수가 많으면 실행할 때 매개변수 값의 개수나 순서를 혼동할 소지가 매우 많다.
--그런 경우에는 아래 예시와 같이 매개변수와 입력 값을 매핑해 실행하면 매우 편리하다.
/*
<프로시저 실행2>
EXEC 혹은 EXECUTE 프로시저명(매개변수1 => 메개변수1 값,
                                                매개변수2 => 매개변수2 값, ...);
*/

-- '=>' 기호를 사용해 해당 매개변수명과 값을 연결하는 형태로 실행할 수 있다. MY_NEW_JOB_PROC 프로시저를 이 형태로 실행해보겠다.
EXECUTE MY_NEW_JOB_PROC ( P_JOB_ID => 'SM_JOB1', P_JOB_TITLE => 'Sample JOB1', P_MIN_SAL => 2000, P_MAX_SAL => 7000);
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--매개변수 디폴트 값 설정
--프로시저를 실행할 떄는 반드시 매개변수의 개수에 맞춰 값을 전달해 실행해야 한다. 만약 매개변수 값을 누락하면 다음과 같이 오류가 발생한다.
--'MY_NEW_JOB_PROC' 호출 시 인수의 개수나 유형이 잘못되었습니다.
EXECUTE MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1');

--프로시저의 매개변수에 디폴트 값을 설정하면 실행할 때 해당 매개변수를 전달하지 않더라고 오류가 나지 않고 디폴트로 설정한 값이 해당 매개변수에 적용된다.
--MY_NEW_JOB_PROC 프로시저의 최소, 최대 급여의 디폴트 값을 각각 10과 100으로 값을 설정해 보겠다.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PROC
(P_JOB_ID IN JOBS.JOB_ID%TYPE,
 P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
 P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 10, --디폴트 값 설정
 P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 100) -- 디폴트 값 설정
IS
  VN_CNT NUMBER := 0;
BEGIN
    -- 동일한 JOB_ID가 있는 지 체크
    SELECT COUNT(*)
    INTO VN_CNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    -- 없으면 INSERT
    IF VN_CNT = 0 THEN
        INSERT INTO JOBS ( JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY,
                                        CREATE_DATE, UPDATE_DATE)
                            VALUES( P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL,
                                        SYSDATE, SYSDATE);
    ELSE -- 있으면 UPDATE
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

--JOB_ID와 JOB_TITLE 값만 절달해 프로시저 실행
--최소, 최대 급여 매개변수를 전달하지 않았어도 디폴트 값을 설정하면 이 값이 매개 변수 에할당되어 처리되었음을 알 수 있다.
--한 가지 주의할 점은 디폴트 값은 IN 매개변수에만 사용할 수 있다.
EXECUTE MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1');
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

--OUT, IN OUT 매개변수
--프로시저와 함수의 가장 큰 차이점은 반환 값의 존재 여부다.
--프로시저는 원래 반환 값이 없으나 OUT 매개변수를 통해 값을 반환할 수 있다.
--OUT 매개변수란 프로시저 실행 시점에 OUT 매개변수를 변수 형태로 전달하고, 프로시저 실행부에서 이 매개변수에 특정 값을 할당한다.
--실행이 끝나면 전달한 변수를 참조해 값을 가져올 수 있는 것이다.
--프로시저 생성 시 매개변수명과 데이터 타입만 명시하면 디폴트로 IN 매개변수가 되지만 OUT 매개변수는 반드시 OUT 키워드를 명시해야한다.

--MY_NEW_JOB_PROC에서 갱신일자를 받는 OUT 매개변수를 추가해 보겠다.
--기존 JOBS 테이블의 CREATE_DATE, UPDATE_DATE 컬럼 값으로 SYSDATE를 직접 입력했지만
--이번에는 VN_CUR_DATE 변수를 선언해 SYSDATE로 초기화한 뒤, 이 변수를 사용했다.
--이렇게 처리한 이유는 SYSDATE는 초 단위로 값이 바뀌므로 JOBS 테이블에 입력되거나 갱신된 일자 값을 정확히 가져오기 위해서다.
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

 -- 동일한 JOB_ID가 있는지 체크
 SELECT COUNT(*)
 INTO VN_CNT
 FROM JOBS
 WHERE JOB_ID = P_JOB_ID;
 
 -- 없으면 INSERT
 IF VN_CNT = 0 THEN
    INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY, CREATE_DATE, UPDATE_DATE)
                        VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL, VN_CUR_DATE, VN_CUR_DATE);
 ELSE -- 있으면 UPDATE
    UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
                MIN_SALARY = P_MIN_SAL,
                MAX_SALARY = P_MAX_SAL,
                UPDATE_DATE = VN_CUR_DATE
        WHERE JOB_ID = P_JOB_ID;
    END IF;
    
    -- OUT 매개변수에 일자 할당
    P_UPD_DATE := VN_CUR_DATE;
    
    COMMIT;
END;
/

--프로시저를 실행하고 OUT 매개변수 값을 참조해야 하는데, 이때 별도의 변수를 선언해서 매개변수로 전달한 뒤 값을 참조해야 한다.
--변수가 필요하므로 이 프로시저를 실행하는 익명 블록을 만들어 보겠다.
--"MY_NEW_JOB_PROC"를 만났습니다 다음 중 하나가 기대될 때: 라는 오류가 발생했다.
--익명 블록에서 프로시저를 실행하면 EXEC나 EXECUTE를 붙이지 않는다.
DECLARE
    VD_CUR_DATE JOBS.UPDATE_DATE%TYPE;
BEGIN
    EXEC MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000, VD_CUR_DATE);
    
    DBMS_OUTPUT.PUT_LINE(VD_CUR_DATE);
END;
/

--EXEC, EXECUTE를 제거하고 실행
DECLARE
    VD_CUR_DATE JOBS.UPDATE_DATE%TYPE;
BEGIN
    MY_NEW_JOB_PROC ('SM_JOB1', 'Sample JOB1', 2000, 6000, VD_CUR_DATE);
    
    DBMS_OUTPUT.PUT_LINE(VD_CUR_DATE);
END;
/

--IN OUT 매개변수(입력과 출력을 동시에 사용할 수 있다.)
--프로시저 실행 시 OUT 매개변수에 전달할 변수에 값을 할당해서 넘겨줄 수 있지만 큰 의미는 없는 일이다.
--OUT 매개변수는 해당 프로시저가 성공적으로 실행을 완료할 때까지 값이 할당되지 않는다.
--따라서 매개변수에 값을 전달해서 사용한 다음 다시 이 매개변수에 값을 받아와 참조하고 싶다면 IN OUT 매개변수를 사용해야한다.

--간단한 IN OUT 예시
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

--프로시저 실행
--P_VAR로 시작되는 결과는 MY_PARAMETER_TEST_PROC 내부에서 출력한 것이고, V_VAR로 시작되는 결과는 이 프로시저를 실행한 익명 블록에서 출력한 것이다.
--OUT 매개변수인 P_VAR2 자리에 V_VAR2 변수를 넣어 'B'라는 값을 넘겨 줬음에도 불구하고 아무런 값도 없음을 확인할 수 있다.
--이에 반해 IN OUT 매개변수인 P_VAR3에는 'C'란 값을 넘겨 줘서 MY_PARAMETER_TEST_PROC 내부에서 이 값을 받아 출력했고
--다시 'C2'로 값을 할당해서 최종적으로 V_VAR3 값은 'C2'가 된 것이다.
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

--IN, OUT, IN OUT 정리
--IN 매개변수는 참조만 가능하며 값을 할당할 수 없다.
--OUT 매개변수에 값을 전달할 수는 있지만 의미가 없다.
--OUT, IN OUT 매개변수에는 디폴트 값을 설정할 수 없다.
--IN 매개변수에는 변수나 상수, 각 데이터 유형에 따른 값을 전달할 수 있지만, 
--OUT, IN OUT 매개변수를 전달할 때는 반드시 변수 형태로 값을 넘겨줘야 한다.

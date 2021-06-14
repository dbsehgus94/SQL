/*
5. 아래 프로시저는 이번 장에서 학습했던 my_new_job_proc 프로시저이다.
이 프로시저는 JOBS 테이블에 기존 데이터가 없으면 INSERT, 있으면 UPDATE를 수행하는데
IF문을 사용해 구현하였다. IF문을 제거하고 동일한 로직을 처리하도록 MERGE문을 사용해
my_new_job_proc2 란 프로시저를 생성해 보겠다.
*/
/*
CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
  vn_cnt NUMBER := 0;
BEGIN
-- 동일한 job_id가 있는지 체크
SELECT COUNT(*)
  INTO vn_cnt
  FROM JOBS
 WHERE job_id = p_job_id;
	 
-- 없으면 INSERT 
IF vn_cnt = 0 THEN 
   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
ELSE -- 있으면 UPDATE
	UPDATE JOBS
	    SET job_title   = p_job_title,
	        min_salary  = p_min_sal,
	        max_salary  = p_max_sal,
	        update_date = SYSDATE
	   WHERE job_id = p_job_id;	
END IF;
COMMIT;		
END ;
/
*/

/*
MERGE 조건
MERGE INTO 테이블명
USING(update or insert 될 데이터 원천)
ON (update 될 조건)
WHEN MATCHED THEN
    SET 컬럼1=값1, 컬럼2=값2,...
    WHERE update 조건;
WHEN NOT MATCHED THEN
    INSERT (컬럼1, 컬럼2,...) VALUES (값1, 값2,...)
    WHERE insert 조건;
*/

CREATE OR REPLACE PROCEDURE my_new_job_proc2
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
BEGIN
    MERGE INTO JOBS A
    USING (SELECT P_JOB_ID AS JOB_ID FROM DUAL) B
    ON (A.JOB_ID = B.JOB_ID)
    WHEN MATCHED THEN
    UPDATE SET A.JOB_TITLE = P_JOB_TITLE,
               A.MIN_SALARY = P_MIN_SAL,
               A.MAX_SALARY = P_MAX_SAL
    WHEN NOT MATCHED THEN
    INSERT (A.JOB_ID, A.JOB_TITLE, A.MIN_SALARY, A.MAX_SALARY, A.CREATE_DATE, A.UPDATE_DATE)
    VALUES (P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL, SYSDATE, SYSDATE);
    
    COMMIT;
END;
/
EXEC my_new_job_proc('IT_PM', 'PROJECT MANAGER', 2800, 7000);

SELECT JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY
FROM JOBS
WHERE JOB_ID LIKE 'IT%';
/*
6. 부서 테이블의 복사본 테이블을 다음과 같이 만들어보자.
CREATE TABLE ch09_departments AS
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, PARENT_ID
FROM DEPARTMENTS;

위 테이블을 대상으로 다음과 같은 처리를 하는 프로시저를 my_dept_manage_proc란 이름으로 만들어보자.
(1) 매개변수 : 부서번호, 부서명, 상위부서번호, 동작 flag
(2) 동작 flag 매개변수 값은 'upsert' -> 데이터가 있으면 UPDATE, 아니면 INSERT
                          'delete' -> 해당 부서 삭제
(3) 삭제 시, 만약 해당 부서에 속한 사원이 존재하는지 사원테이블을 체크해 존재하면 경고메시지와 함께 delete를 하지 않는다.        
*/

CREATE OR REPLACE PROCEDURE my_dept_manage_proc
    (P_DEPARTMENT_ID    IN CH09_DEPARTMENTS.DEPARTMENT_ID%TYPE,
     P_DEPARTMENT_NAME  IN CH09_DEPARTMENTS.DEPARTMENT_NAME%TYPE,
     P_PARENT_ID        IN CH09_DEPARTMENTS.PARENT_ID%TYPE,
     P_FLAG             IN VARCHAR2)

IS
  vn_cnt1 NUMBER := 0;
  vn_cnt2 NUMBER := 0;
BEGIN
	
	-- INSERT나 UPDATE 할 경우, 동작 flag 매개변수가 소문자로 들어올 수 있으므로 대문자로 변환 후 비교함 
	IF UPPER(p_flag) = 'UPSERT' THEN
	
	  MERGE INTO ch09_departments a
  	USING ( SELECT p_department_id AS department_id
	            FROM DUAL ) b
	     ON ( a.department_id = b.department_id )
	   WHEN MATCHED THEN
	     UPDATE SET a.department_name  = p_department_name, 
	                a.parent_id        = p_parent_id
	   WHEN NOT MATCHED THEN 
	     INSERT ( a.department_id, a.department_name, a.parent_id )
	     VALUES ( p_department_id, p_department_name, p_parent_id );	
	
	-- 삭제할 경우
	ELSIF UPPER(p_flag) = 'DELETE' THEN
	
	   -- 해당 부서가 있는지 체크
	   SELECT COUNT(*)
	     INTO vn_cnt1
	     FROM ch09_departments
	    WHERE department_id = p_department_id;
	    
	   -- 해당 부서가 없으면 메시지와 함께 프로시저 종료 
	   IF vn_cnt1 = 0 THEN
	      DBMS_OUTPUT.PUT_LINE('해당 부서가 없어 삭제할 수 없습니다');
	      RETURN;
	   END IF;
	   
	   -- 해당 부서에 속한 사원이 있는지 체크
	   SELECT COUNT(*)
	     INTO vn_cnt2
	     FROM employees
	    WHERE department_id = p_department_id;
	    
	   -- 해당 부서에 속한 사원이 있으면 메시지와 함께 프로시저 종료 
	   IF vn_cnt2 > 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재하므로 삭제할 수 없습니다');
	      RETURN;	   	   
	   END IF;
	   
	   DELETE ch09_departments
	    WHERE department_id = p_department_id;
	
  END IF;
	
	COMMIT;

END ;
/
EXEC my_dept_manage_proc(280, 'IT 기획', 90, 'upsert');
EXEC my_dept_manage_proc(280, 'IT 기획', 90, 'delete');



/*
5. �Ʒ� ���ν����� �̹� �忡�� �н��ߴ� my_new_job_proc ���ν����̴�.
�� ���ν����� JOBS ���̺� ���� �����Ͱ� ������ INSERT, ������ UPDATE�� �����ϴµ�
IF���� ����� �����Ͽ���. IF���� �����ϰ� ������ ������ ó���ϵ��� MERGE���� �����
my_new_job_proc2 �� ���ν����� ������ ���ڴ�.
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
-- ������ job_id�� �ִ��� üũ
SELECT COUNT(*)
  INTO vn_cnt
  FROM JOBS
 WHERE job_id = p_job_id;
	 
-- ������ INSERT 
IF vn_cnt = 0 THEN 
   INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
             VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
ELSE -- ������ UPDATE
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
MERGE ����
MERGE INTO ���̺��
USING(update or insert �� ������ ��õ)
ON (update �� ����)
WHEN MATCHED THEN
    SET �÷�1=��1, �÷�2=��2,...
    WHERE update ����;
WHEN NOT MATCHED THEN
    INSERT (�÷�1, �÷�2,...) VALUES (��1, ��2,...)
    WHERE insert ����;
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
6. �μ� ���̺��� ���纻 ���̺��� ������ ���� ������.
CREATE TABLE ch09_departments AS
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, PARENT_ID
FROM DEPARTMENTS;

�� ���̺��� ������� ������ ���� ó���� �ϴ� ���ν����� my_dept_manage_proc�� �̸����� ������.
(1) �Ű����� : �μ���ȣ, �μ���, �����μ���ȣ, ���� flag
(2) ���� flag �Ű����� ���� 'upsert' -> �����Ͱ� ������ UPDATE, �ƴϸ� INSERT
                          'delete' -> �ش� �μ� ����
(3) ���� ��, ���� �ش� �μ��� ���� ����� �����ϴ��� ������̺��� üũ�� �����ϸ� ���޽����� �Բ� delete�� ���� �ʴ´�.        
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
	
	-- INSERT�� UPDATE �� ���, ���� flag �Ű������� �ҹ��ڷ� ���� �� �����Ƿ� �빮�ڷ� ��ȯ �� ���� 
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
	
	-- ������ ���
	ELSIF UPPER(p_flag) = 'DELETE' THEN
	
	   -- �ش� �μ��� �ִ��� üũ
	   SELECT COUNT(*)
	     INTO vn_cnt1
	     FROM ch09_departments
	    WHERE department_id = p_department_id;
	    
	   -- �ش� �μ��� ������ �޽����� �Բ� ���ν��� ���� 
	   IF vn_cnt1 = 0 THEN
	      DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ������ �� �����ϴ�');
	      RETURN;
	   END IF;
	   
	   -- �ش� �μ��� ���� ����� �ִ��� üũ
	   SELECT COUNT(*)
	     INTO vn_cnt2
	     FROM employees
	    WHERE department_id = p_department_id;
	    
	   -- �ش� �μ��� ���� ����� ������ �޽����� �Բ� ���ν��� ���� 
	   IF vn_cnt2 > 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����ϹǷ� ������ �� �����ϴ�');
	      RETURN;	   	   
	   END IF;
	   
	   DELETE ch09_departments
	    WHERE department_id = p_department_id;
	
  END IF;
	
	COMMIT;

END ;
/
EXEC my_dept_manage_proc(280, 'IT ��ȹ', 90, 'upsert');
EXEC my_dept_manage_proc(280, 'IT ��ȹ', 90, 'delete');



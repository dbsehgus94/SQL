--21년 6월 3일 수업내용
--기존 문법(외부조인)
select a.employee_id, a.emp_name, b.job_id, b.department_id
from employees a,
    job_history b
where a.employee_id = b.employee_id(+)
and a.department_id = b.department_id(+);

--ANSI 문법(LEFT JOIN)
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT OUTER JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--ANSI 문법(RIGHT JOIN)    
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--OUTER 생략 가능
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a
LEFT JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
--WHERE 절에 조인 조건을 명시하지 않은 카타시안 조인이 있는데, ANSI 조인에서는 CROSS 조인이라고 한다.
--기존 문법
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b;
    
--ANSI 문법
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;

--테이블 생성 및 값 삽입 후 커밋
CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);
INSERT INTO HONG_A VALUES( 10);
INSERT INTO HONG_A VALUES( 20);
INSERT INTO HONG_A VALUES( 40);
INSERT INTO HONG_B VALUES( 10);
INSERT INTO HONG_B VALUES( 20);
INSERT INTO HONG_B VALUES( 30);
COMMIT;

--오류: OUTER-JOIN된 테이블은 1개만 지정할 수 있다.
--외부 조인 조건에서는 한 쪽에만 (+)를 붙일 수 있다.
SELECT a.emp_id, b.emp_id
FROM hong_a a,
    hong_b b
WHERE a.emp_id(+) = b.emp_id(+);

--FULL JOIN 사용
--FULL -> 두 테이블 모두를 외부 조인 대상에 넣을 수 있다.
SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
ON (a.emp_id = b.emp_id);

--서브 쿼리
--메인쿼리와의 연관성이 없는 서브 쿼리
--메인 테이블과 조인 조건이 걸리지 않음

--서브 쿼리에서 먼저 평균 급여를 구한 뒤 메인 쿼리에서는 이 평균값보다 큰 사원을 조회
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary)
    FROM employees);
--위의 서브 쿼리에서 단일 행을 반환했지만 밑의 서브 쿼리는 여러 행을 반환했다.
SELECT count(*)
FROM employees
WHERE department_id IN ( SELECT department_id
                           FROM departments
                          WHERE parent_id IS NULL);

--동시에 2개 이상의 컬럼 값이 같은 건을 찾고 있다. 
--IN 앞에 있는 컬럼 개수와 서브 쿼리에서 반환하는 컬럼 개수와 유형은 같아야 한다.
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                FROM job_history);

--전 사원의 급여를 평균 금액으로 갱신(UPDATE문)
UPDATE employees
SET salary = ( SELECT AVG(salary)
                 FROM employees);
                 
--평균 급여보다 많이 받는 사원 삭제(DELETE문)
DELETE employees
WHERE salary >= ( SELECT AVG(salary)
                    FROM employees);

--사원 테이블을 원 상태로 되돌려 놓도록 ROLLBACK 문을 실행.
ROLLBACK;

--연관성 있는 서브 쿼리(메인 쿼리와의 연관성이 있는 서브 쿼리, 즉 메인 테이블 과 조인 조건이 걸린 서브 쿼리)

--서브 쿼리 안에서 메인 쿼리에서 사용된 부서 테이블의 부서번호와
--job_history 테이블의 부서번호가 같은 건을 조회하고 있다.
--EXISTS 연산자를 사용하여 서브 쿼리 내에 조인 조건이 포함됨.
--결과값은 job_history 테이블에 있는 부서만 조회됨.
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS( SELECT 1
                FROM job_history b
               WHERE a.department_id = b.department_id);

--job_history에 사번, 부서번호만 존재하므로 사원명과 부서명을 가져오기 위해
--서브 쿼리를 SELECT 절에서 사용했고, 서브 쿼리 안의 WHERE 절에 조건을 추가함.
--SELECT 절 자체에서도 여러 개의 서브 쿼리를 넣을 수 있음.
--각 서브 쿼리가 독립적이므로 두 개의 서브 쿼리에서 사용된 사원, 부서 테이블의 별칭을 모두
--b로 사용해도 무방함.
SELECT a.employee_id,
    ( SELECT b.emp_name
        FROM employees b
        WHERE a.employee_id = b.employee_id) AS emp_name,
    a.department_id,
    ( SELECT b.department_name
        FROM departments b
        WHERE a.department_id = b.department_id) AS dep_name
    FROM job_history a;

--2개의 서브 쿼리가 사용됨.
--(SELECT AVG(salary) FROM employees)에서 평균급여를 구하고
--이 값보다 큰 급여의 사원을 걸러낸 다음(연관성 없는 서브 쿼리)
--WHERE a.department_id = b.department_id 에서 평균급여 이상을 받는 
--사원이 속한 부서를 추출한 것(연관성 있는 서브 쿼리).                                  
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS ( SELECT 1
                FROM employees b
                WHERE a.department_id = b.department_id
                AND b.salary > ( SELECT AVG(salary)
                                    FROM employees)
            );

--부서 테이블에서 상위 부서가 기획부(부서번호가 90)에 속하는 사원들의 부서별 평균 급여를 조회
SELECT department_id, AVG(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                          FROM departments
                          WHERE parent_id=90)
GROUP BY department_id;

--상위 부서가 기획부에 속하는 모든 사원의 급여를 자신의 부서별 평균급여로 갱신하는 쿼리.
UPDATE employees a
    SET a.salary = (SELECT sal
                                FROM (SELECT b.department_id, AVG(c.salary) as sal
                                                FROM departments b,
                                                            employees c
                                                WHERE b.parent_id = 90
                                                     AND b.department_id = c.department_id
                                                GROUP BY b.department_id) d
                                WHERE a.department_id = d.department_id)
    WHERE a.department_id IN (SELECT department_id
                                                    FROM departments
                                                    WHERE parent_id = 90);

--부서별 최소와 최대 금액이 모두 같고, 위에서 구한 부서별 평균값으로 갱신되었으므로 제대로 처리됨.
SELECT department_id, MIN(salary), MAX(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                                            FROM departments
                                        WHERE parent_id = 90)
GROUP BY department_id;
 
 --MERGE문으로 변경.
MERGE INTO employees a
USING (SELECT b.department_id, AVG(c.salary) as sal
                FROM departments b,
                            employees c
                WHERE b.parent_id = 90
                AND b.department_id = c.department_id
                GROUP BY b.department_id) d
            ON  (a.department_id = d.department_id)
WHEN MATCHED THEN
UPDATE SET a.salary = d.sal;

--변경한 데이터를 원 상태로 되돌려 놓도록 ROLLBACK문을 실행.
ROLLBACK;

--인라인 뷰(FROM 절에 사용하는 서브 쿼리)
--서브 쿼리를 FROM 절에 사용하여 하나의 테이블이나 뷰처럼 사용할 수 있다.
--뷰를 해체하면 하나의 독립적인 SELECT문이므로 FROM 절에 사용하는 서브 쿼리도 하나의 뷰로 볼 수 있어 인라인 뷰라고 한다.

--기획부(90) 산하에 있는 부서에 속한 사원의 평균급여보다 많은 급여를 받는 사원목록을 추출한 것인데
--기획부 산하 평균급여를 구하는 부분을 서브 쿼리로 작성했고 이를 FROM 절에 위치시킴.
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
            departments b,
            (SELECT AVG(c.salary) AS avg_salary
                FROM departments b,
                            employees c
                WHERE b.parent_id = 90 -- 기획부
                AND b.department_id = c.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary;

--
SELECT a.*
FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
            FROM sales a,
                       customers b,
                       countries c
            WHERE a.sales_month BETWEEN '2200001' AND '200012'
                AND a.cust_id = b.CUST_ID
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
            GROUP BY a.sales_month
            ) a,
            ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                    FROM sales a,
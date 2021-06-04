--1번. 101번 사원에 대해 아래의 결과를 산출하는 쿼리를 작성해 보자.
-- 사번 사원명 job명칭 job시작일자 job종료일자 job수행부서명
SELECT a.employee_id AS 사번, a.emp_name AS 사원명, d.job_title AS job명칭, 
    c.start_date AS job시작일자, c.end_date AS job종료일자, b.department_name AS job수행부서명
FROM employees a,
     departments b,
     job_history c,
     jobs d
WHERE a.employee_id = c.employee_id
  AND c.department_id = b.department_id
  AND c.job_id = d.job_id
  AND a.employee_id = 101;
  
--2번. 아래의 쿼리를 수행하면 오류가 발생한다. 오류의 원인은 무엇인가?
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id(+) = b.department_id;
--오류 내용 : 두 개의 테이블을 outer-join 할 수 없습니다.
--외부 조인의 경우, 조인조건에 데이터가 없는 테이블의 컬럼에만 (+)를 붙여야 한다.
--따라서 위 쿼리의 경우, and a.department_id(+) = b.department_id 가 아닌
--a.department_id = b.department_id(+)로 고쳐야 한다.
--정답
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

--3번. 외부 조인시 (+)연산자를 같이 사용할 수 없는데, IN절에 사용하는 값이 1개인 경우는
--사용 가능하다. 그 이유는 무엇일까?
--오라클은 IN 절에 포함된 값을 기준으로 OR로 변환한다.
--departmant_id IN (10, 20, 30)은
--department_id = 10
--OR department_id = 20
--OR department_id = 30으로 바꾸어 쓸 수 있다.
--그런데 IN절에 값이 1개인 경우, 즉 department_id IN (10)일 경우
--department_id = 10으로 변환할 수 있으므로, 외부조인을 하더라도 값이 1개인 경우는 사용할 수 있다.

--4번. 다음의 쿼리를 ANSI 문법으로 변경해 보자.
SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
AND b.salary > 3000
ORDER BY a.department_name;
--ANSI 문법으로 변경한 쿼리
SELECT a.department_id, a.department_name
FROM departments a
INNER JOIN employees b
    ON (a.department_id = b.department_id)
WHERE b.salary > 3000
ORDER BY a.department_name;

--5번. 다음은 연관성 있는 서브쿼리이다. 이를 연관성 없는 서브쿼리로 변환해 보자.
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
                FROM job_history b
               WHERE a.department_id = b.department_id);
--정답
SELECT a.department_id, a.department_name
FROM departments a
WHERE a.department_id IN (SELECT department_id
                            FROM job_history);


SELECT COUNT(*)
FROM employees;

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;

SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;

SELECT SUM(salary)
FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;

SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;

SELECT MIN(salary), MAX(salary)
FROM employees;

SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;

SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT *
FROM kor_loan_status;

SELECT period, region, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region;

SELECT period, region, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region
ORDER BY region;

SELECT period, region, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt)>100000
ORDER BY period, region;

SELECT period, region, loan_jan_amt, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201310'
GROUP BY period, region, loan_jan_amt
HAVING loan_jan_AMT < 2600
ORDER BY totl_jan ASC;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun );

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period), gubun;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, CUBE(gubun);

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period), gubun;

CREATE TABLE exp_goods_asia (
    country VARCHAR2(10),
    seq     NUMBER,
    goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5, 'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7, '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8, '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10, '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '한국';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT seq, goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT seq, goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT seq
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY goods
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY goods;

SELECT TO_CHAR(hire_date, 'YYYY') AS hire_year,
COUNT(*)
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY TO_CHAR(hire_date, 'YYYY');

SELECT period, region, SUM(loan_jan_amt) AS total_amt
FROM kor_loan_status
WHERE period LIKE '2012%'
GROUP BY period, region
ORDER BY period, region;

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun);

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
UNION
SELECT period, '', SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;


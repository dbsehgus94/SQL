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

INSERT INTO exp_goods_asia VALUES ('????', 1, '???????? ??????');
INSERT INTO exp_goods_asia VALUES ('????', 2, '??????');
INSERT INTO exp_goods_asia VALUES ('????', 3, '????????????');
INSERT INTO exp_goods_asia VALUES ('????', 4, '????');
INSERT INTO exp_goods_asia VALUES ('????', 5, 'LCD');
INSERT INTO exp_goods_asia VALUES ('????', 6, '??????????');
INSERT INTO exp_goods_asia VALUES ('????', 7, '????????');
INSERT INTO exp_goods_asia VALUES ('????', 8, '????????????');
INSERT INTO exp_goods_asia VALUES ('????', 9, '?????????? ?????????? ??????');
INSERT INTO exp_goods_asia VALUES ('????', 10, '?? ???? ????????');

INSERT INTO exp_goods_asia VALUES ('????', 1, '??????');
INSERT INTO exp_goods_asia VALUES ('????', 2, '??????????');
INSERT INTO exp_goods_asia VALUES ('????', 3, '????????????');
INSERT INTO exp_goods_asia VALUES ('????', 4, '????');
INSERT INTO exp_goods_asia VALUES ('????', 5, '????????????');
INSERT INTO exp_goods_asia VALUES ('????', 6, '??????');
INSERT INTO exp_goods_asia VALUES ('????', 7, '???????? ??????');
INSERT INTO exp_goods_asia VALUES ('????', 8, '????????');
INSERT INTO exp_goods_asia VALUES ('????', 9, '????????, ??????????');
INSERT INTO exp_goods_asia VALUES ('????', 10, '??????');

COMMIT;

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '????';

SELECT seq, goods
FROM exp_goods_asia
WHERE country = '????'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '????';

SELECT seq, goods
FROM exp_goods_asia
WHERE country = '????'
INTERSECT
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '????';

SELECT seq
FROM exp_goods_asia
WHERE country = '????'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
ORDER BY goods
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '????';

SELECT goods
FROM exp_goods_asia
WHERE country = '????'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '????'
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


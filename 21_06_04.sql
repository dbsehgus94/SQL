--2000년 이탈리아 평균 매출액(연평균)보다 큰 월의 평균 매출액을 구함.
--첫 번째 서브 쿼리에서는 월별 평균 매출액을 구함.
--두 번째 서브 쿼리에서는 연평균 매출액을 구해서
--월 평균매출액 > 연 평균매출액 조건을 만족하는 월의 평균매출액을 구한 것.
SELECT a.*
FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
            FROM sales a,
                       customers b,
                       countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
            GROUP BY a.sales_month
            ) a,
            ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                    FROM sales a,
                        customers b,
                        countries c
                   WHERE a.sales_month BETWEEN '200001' AND '200012'
                     AND a.cust_id = b.CUST_ID
                     AND b.COUNTRY_ID = c.COUNTRY_ID
                     AND c.COUNTRY_NAME = 'Italy'  -- 이탈리아
            ) b
WHERE a.month_avg > b.year_avg;

--복잡한 쿼리를 작성할 때의 가이드
--1. 최종적으로 조회되는 결과 항목을 정의한다.
--2. 필요한 테이블과 컬럼을 파악한다.
--3. 작은 단위로 분할해서 쿼리를 작성한다.
--4. 분할한 단위의 쿼리를 하나로 합쳐 최종 결과를 산출한다.
--5. 결과를 검증한다.

--(1) 출력항목
--연도, 최대매출사원명, 최대매출액

--(2) 필요한 테이블
--이탈리아 찾기 :  countries
--이탈리아 고객 찾기 : customers
--매출 : sales
--사원정보 : employees

--(3) 단위분할
--연도, 사원별 이탈리아 매출액 구하기
--이탈리아 고객 찾기 : customers, countries를 country_id로 조인, country_name 이 'ltaly'인 것을 찾기
--이탈리아 매출 찾기 : 위 결과와 sales 테이블을 cust_id로 조인
--최대 매출액을 구하려면 MAX 함수를 쓰고, 연도별로 GROUP BY 필요
SELECT SUBSTR(a.sales_month, 1, 4) as years,
        a.employee_id,
        SUM(a.amount_sold) AS amount_sold
   FROM sales a,
        customers b,
        countries c
  WHERE a.cust_id = b.CUST_ID
    AND b.country_id = c.COUNTRY_ID
    AND c.country_name = 'Italy'
  GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id;
--위에서 구한 결과에서 연도별 최대, 최소 매출액 구하기
SELECT years,
       MAX(amount_sold) AS max_sold
  FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
               a.employee_id,
               SUM(a.amount_sold) AS amount_sold
          FROM sales a,
               customers b,
               countries c
         WHERE a.cust_id = b.CUST_ID
           AND b.country_id = c.COUNTRY_ID
           AND c.country_name = 'Italy'
        GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
        ) K
  GROUP BY years
  ORDER BY years;
--첫 번째 쿼리 결과와 두 번째 쿼리 결과를 조인해서 최대매출, 최소매출액을 일으킨 사원을
--찾아야 하므로, 첫 번째 쿼리 결과와 두 번째 쿼리 결과를 인라인 뷰로 만듬.
SELECT emp.years,
       emp.employee_id,
       emp.amount_sold
  FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
               a.employee_id,
               SUM(a.amount_sold) AS amount_sold
          FROM sales a,
               customers b,
               countries c
         WHERE a.cust_id = b.CUST_ID
           AND b.country_id = c.COUNTRY_ID
           AND c.country_name = 'Italy'
         GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
        ) emp,
        (SELECT years,
                MAX(amount_sold) AS max_sold
          FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
                       a.employee_id,
                       SUM(a.amount_sold) AS amount_sold
                  FROM sales a,
                       customers b,
                       countries c
                 WHERE a.cust_id = b.CUST_ID
                   AND b.country_id = c.COUNTRY_ID
                   AND c.country_name = 'Italy'
                 GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
                ) K
         GROUP BY years
    ) sale
WHERE emp.years = sale.years
  AND emp.amount_sold = sale.max_sold
ORDER BY years;
--마지막으로 위 쿼리 결과와 사원 테이블을 조인해서 사원 이름을 가져온다.
SELECT emp.years,
       emp.employee_id,
       emp.amount_sold
  FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
               a.employee_id,
               SUM(a.amount_sold) AS amount_sold
          FROM sales a,
               customers b,
               countries c
         WHERE a.cust_id = b.CUST_ID
           AND b.country_id = c.COUNTRY_ID
           AND c.country_name = 'Italy'
         GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
        ) emp,
        (SELECT years,
                MAX(amount_sold) AS max_sold
          FROM (SELECT SUBSTR(a.sales_month, 1, 4) as years,
                       a.employee_id,
                       SUM(a.amount_sold) AS amount_sold
                  FROM sales a,
                       customers b,
                       countries c
                 WHERE a.cust_id = b.CUST_ID
                   AND b.country_id = c.COUNTRY_ID
                   AND c.country_name = 'Italy'
                 GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id
                ) K
         GROUP BY years
    ) sale,
    employees emp2
WHERE emp.years = sale.years
  AND emp.amount_sold = sale.max_sold
  AND emp.employee_id = emp2.employee_id
ORDER BY years;
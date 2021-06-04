--2000�� ��Ż���� ��� �����(�����)���� ū ���� ��� ������� ����.
--ù ��° ���� ���������� ���� ��� ������� ����.
--�� ��° ���� ���������� ����� ������� ���ؼ�
--�� ��ո���� > �� ��ո���� ������ �����ϴ� ���� ��ո������ ���� ��.
SELECT a.*
FROM (SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
            FROM sales a,
                       customers b,
                       countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- ��Ż����
            GROUP BY a.sales_month
            ) a,
            ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                    FROM sales a,
                        customers b,
                        countries c
                   WHERE a.sales_month BETWEEN '200001' AND '200012'
                     AND a.cust_id = b.CUST_ID
                     AND b.COUNTRY_ID = c.COUNTRY_ID
                     AND c.COUNTRY_NAME = 'Italy'  -- ��Ż����
            ) b
WHERE a.month_avg > b.year_avg;

--������ ������ �ۼ��� ���� ���̵�
--1. ���������� ��ȸ�Ǵ� ��� �׸��� �����Ѵ�.
--2. �ʿ��� ���̺�� �÷��� �ľ��Ѵ�.
--3. ���� ������ �����ؼ� ������ �ۼ��Ѵ�.
--4. ������ ������ ������ �ϳ��� ���� ���� ����� �����Ѵ�.
--5. ����� �����Ѵ�.

--(1) ����׸�
--����, �ִ��������, �ִ�����

--(2) �ʿ��� ���̺�
--��Ż���� ã�� :  countries
--��Ż���� �� ã�� : customers
--���� : sales
--������� : employees

--(3) ��������
--����, ����� ��Ż���� ����� ���ϱ�
--��Ż���� �� ã�� : customers, countries�� country_id�� ����, country_name �� 'ltaly'�� ���� ã��
--��Ż���� ���� ã�� : �� ����� sales ���̺��� cust_id�� ����
--�ִ� ������� ���Ϸ��� MAX �Լ��� ����, �������� GROUP BY �ʿ�
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
--������ ���� ������� ������ �ִ�, �ּ� ����� ���ϱ�
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
--ù ��° ���� ����� �� ��° ���� ����� �����ؼ� �ִ����, �ּҸ������ ����Ų �����
--ã�ƾ� �ϹǷ�, ù ��° ���� ����� �� ��° ���� ����� �ζ��� ��� ����.
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
--���������� �� ���� ����� ��� ���̺��� �����ؼ� ��� �̸��� �����´�.
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
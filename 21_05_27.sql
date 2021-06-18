CREATE TABLE PRODUCT (
    PRODUCT_ID  NUMBER(12,0)    PRIMARY KEY,
    PRODUCT_NAME    VARCHAR2(8 BYTE),
    QUANTITY    NUMBER(10,0)    DEFAULT 0,
    ORDER_DATE  DATE,
    ORDER_MODE  VARCHAR2(8 BYTE),
    DESCRIPTION VARCHAR2(20 BYTE),
    STANDARD_COST   NUMBER(4,0),
    LIST_PRICE  NUMBER(8,2) DEFAULT 0,
    CATEGORY_ID NUMBER(6,0),
    PROMOTION_ID    NUMBER(6,0),
    CONSTRAINTS PK_PRODUCT CHECK(ORDER_MODE IN('direct', 'online'))
);

CREATE TABLE exam2_1 (
    employee_id NUMBER(6),
    emp_name    VARCHAR2(80),
    salary      NUMBER(8,2),
    manager_id  NUMBER(6)
);

INSERT INTO exam2_1
SELECT employee_id, emp_name, salary, manager_id
FROM employees
WHERE manager_id = '147'
AND salary BETWEEN '6000' AND '7000'
ORDER BY employee_id;

CREATE TABLE exam2_2 (
    employee_id NUMBER,
    bonus_amt   NUMBER DEFAULT 0
);

INSERT INTO exam2_2 (employee_id)
SELECT e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

COMMIT;
SELECT * FROM exam2_2;

MERGE INTO exam2_2 d
USING (SELECT employee_id, salary, manager_id
        FROM employees
        WHERE manager_id = 146) b
        ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.05
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * 0.02);
    
SELECT *
FROM exam2_2
ORDER BY employee_id;

SELECT employee_id, emp_name
FROM employees
WHERE department_id IS NULL;

SELECT employee_id, salary
FROM employees
WHERE salary >= 4500 AND salary <= 5000
ORDER BY employee_id;
--CALEB HAYDEN

--A10BB

CREATE PROCEDURE Populate_Procedure
AS
BEGIN

-- DROP CONSTRAINTS

ALTER TABLE FACT
DROP CONSTRAINT FK_FACT_CUSTOMER

ALTER TABLE FACT
DROP CONSTRAINT FK_FACT_PRODUCT

ALTER TABLE FACT
DROP CONSTRAINT FK_FACT_EMPLOYEE

ALTER TABLE FACT
DROP CONSTRAINT FK_FACT_TIME

ALTER TABLE CUSTOMERDIM
DROP CONSTRAINT PK_CUSTOMERDIM

ALTER TABLE PRODUCTDIM
DROP CONSTRAINT PK_PRODUCTDIM 

ALTER TABLE EMPLOYEEDIM
DROP CONSTRAINT PK_EMPLOYEEDIM

ALTER TABLE TIMEDIM
DROP CONSTRAINT PK_TIMEDIM 

-- TRUNCATE
TRUNCATE TABLE CUSTOMERDIM
TRUNCATE TABLE PRODUCTDIM
TRUNCATE TABLE EMPLOYEEDIM
TRUNCATE TABLE TIMEDIM
TRUNCATE TABLE FACT
TRUNCATE TABLE STAGING

-- ADD CONSTRAINTS
ALTER TABLE CUSTOMERDIM
ADD CONSTRAINT PK_CUSTOMERDIM PRIMARY KEY (CUSTOMER_ID)

ALTER TABLE PRODUCTDIM
ADD CONSTRAINT PK_PRODUCTDIM PRIMARY KEY (PRODUCT_ID)

ALTER TABLE EMPLOYEEDIM
ADD CONSTRAINT PK_EMPLOYEEDIM PRIMARY KEY (EMPLOYEE_ID)

ALTER TABLE TIMEDIM
ADD CONSTRAINT PK_TIMEID PRIMARY KEY (TIME_ID)

ALTER TABLE FACT
ADD CONSTRAINT FK_FACT_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERDIM(CUSTOMER_ID)

ALTER TABLE FACT
ADD CONSTRAINT FK_FACT_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTDIM(PRODUCT_ID)

ALTER TABLE FACT
ADD CONSTRAINT FK_FACT_EMPLOYEE FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEEDIM(EMPLOYEE_ID)

ALTER TABLE FACT
ADD CONSTRAINT FK_FACT_TIME FOREIGN KEY (TIME_ID) REFERENCES TIMEDIM(TIME_ID)


--POPULATE DIMENSION TABLES
INSERT INTO CUSTOMERDIM
SELECT CUST_CODE, CUST_FNAME, CUST_LNAME, CUST_STREET, CUST_CITY, CUST_STATE, CUST_ZIP 
FROM LGCUSTOMER

INSERT INTO PRODUCTDIM
SELECT P.PROD_SKU, P.PROD_DESCRIPT, P.PROD_TYPE, P.PROD_CATEGORY, P.PROD_PRICE, P.PROD_QOH, P.PROD_MIN, P.BRAND_ID, B.BRAND_NAME
FROM LGPRODUCT P INNER JOIN LGBRAND B ON P.BRAND_ID = B.BRAND_ID

INSERT INTO EMPLOYEEDIM
SELECT 	EMP_NUM, EMP_FNAME, EMP_LNAME, EMP_EMAIL, EMP_PHONE, EMP_HIREDATE, EMP_TITLE, EMP_COMM, DEPT_NUM 
FROM LGEMPLOYEE

INSERT INTO TIMEDIM
SELECT DISTINCT INV_DATE, MONTH(INV_DATE), YEAR(INV_DATE)
FROM LGINVOICE

--POPULATE STAGING TABLE
INSERT INTO STAGING (CUST_CODE, PROD_SKU, EMP_NUM, ORDER_DATE, QUANTITY, PRICE)
SELECT C.CUST_CODE, L.PROD_SKU, E.EMP_NUM, I.INV_DATE AS ORDER_DATE, L.LINE_QTY AS QTY, L.LINE_PRICE AS PRICE
FROM	LGEMPLOYEE E INNER JOIN LGINVOICE I ON E.EMP_NUM = I.EMPLOYEE_ID
		INNER JOIN LGCUSTOMER C ON C.CUST_CODE = I.CUST_CODE INNER JOIN LGLINE L ON I.INV_NUM = L.INV_NUM INNER JOIN
		LGPRODUCT P ON L.PROD_SKU = P.PROD_SKU

UPDATE STAGING
SET	CUSTOMER_ID = C.CUSTOMER_ID
FROM STAGING S INNER JOIN CUSTOMERDIM C ON S.CUST_CODE = C.CUST_CODE

UPDATE STAGING
SET	PRODUCT_ID = P.PRODUCT_ID
FROM STAGING S INNER JOIN PRODUCTDIM P ON S.PROD_SKU = P.PROD_SKU

UPDATE STAGING
SET	EMPLOYEE_ID = E.EMPLOYEE_ID
FROM STAGING S INNER JOIN EMPLOYEEDIM E ON S.EMP_NUM =E.EMP_NUM

UPDATE STAGING
SET TIME_ID = T.TIME_ID
FROM STAGING S INNER JOIN TIMEDIM T ON S.ORDER_DATE = T.ORDER_DATE

INSERT INTO FACT (CUSTOMER_ID, PRODUCT_ID, EMPLOYEE_ID, TIME_ID, QUANTITY, PRICE)
SELECT CUSTOMER_ID, PRODUCT_ID, EMPLOYEE_ID, TIME_ID, QUANTITY, PRICE
FROM STAGING

END
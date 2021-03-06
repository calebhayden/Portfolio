--CALEB HAYDEN

--A10 BA

--GET DATA FROM TABLES
SELECT * 
FROM lgcustomer

SELECT * 
FROM lgproduct

SELECT * 
FROM lgline

SELECT *
FROM lgemployee

SELECT * 
FROM lginvoice

--CREATE CUSTOMER DIMENSION
CREATE TABLE CUSTOMERDIM
(
	CUSTOMER_ID INT IDENTITY NOT NULL,
	CUST_CODE NUMERIC (12),
		CUST_FNAME varchar (20),
		CUST_LNAME varchar (20),
		CUST_STREET varchar (70),
		CUST_CITY varchar (50),
		CUST_STATE varchar (2),
		CUST_ZIP varchar (5)
)
--CREATE EMPLOYEE DIMENSION
CREATE TABLE EMPLOYEEDIM
(
	EMPLOYEE_ID INT IDENTITY NOT NULL,
	EMP_NUM INT,
		EMP_FNAME varchar (20),
		EMP_LNAME varchar (25),
		EMP_EMAIL varchar (25),
		EMP_PHONE varchar (20),
		EMP_HIREDATE datetime,
		EMP_TITLE varchar (45),
		EMP_COMM decimal (2, 2),
		DEPT_NUM int 
)
--CREATE PRODUCT DIMENSION
CREATE TABLE PRODUCTDIM
(
	PRODUCT_ID INT IDENTITY NOT NULL,
	PROD_SKU VARCHAR (15),
		PROD_DESCRIPT varchar (255),
		PROD_TYPE varchar (255),
		PROD_CATEGORY varchar (255),
		PROD_PRICE decimal (10, 2),
		PROD_QOH decimal (10, 0),
		PROD_MIN decimal (10, 0),
		BRAND_ID int,
		BRAND_NAME varchar (255),
)

--CREATE TIME DIMENSION
CREATE TABLE TIMEDIM 
(
	TIME_ID INT IDENTITY NOT NULL,
		ORDER_DATE DATE,
		ORDER_MONTH INT,
		ORDER_YEAR INT
)
		
--CREATE FACT TABLE
Create TABLE FACT
(
	CUSTOMER_ID int NOT NULL,
	PRODUCT_ID INT NOT NULL,
	EMPLOYEE_ID int NOT NULL,
	TIME_ID int NOT NULL,
	PRICE float,
	QUANTITY int
)

--CREATE STAGING TABLE
CREATE TABLE STAGING
(
	CUST_CODE INT,
	PROD_SKU VARCHAR(15),
	EMP_NUM INT,
	ORDER_DATE DATE,
	QUANTITY INT,
	PRICE INT,
	CUSTOMER_ID INT DEFAULT NULL,	
	PRODUCT_ID INT DEFAULT NULL,
	EMPLOYEE_ID INT DEFAULT NULL,
	TIME_ID INT DEFAULT NULL
)

--ALTER TABLES
ALTER TABLE CUSTOMERDIM
	ADD CONSTRAINT PK_CUSTOMERDIM PRIMARY KEY (CUSTOMER_ID);

ALTER TABLE PRODUCTDIM
	ADD CONSTRAINT PK_PRODUCTDIM PRIMARY KEY (PRODUCT_ID);

ALTER TABLE EMPLOYEEDIM
	ADD CONSTRAINT PK_EMPLOYEEDIM PRIMARY KEY (EMPLOYEE_ID);

ALTER TABLE TIMEDIM
	ADD CONSTRAINT PK_TIMEDIM PRIMARY KEY (TIME_ID);

ALTER TABLE FACT
	ADD CONSTRAINT FK_FACT_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERDIM,
		CONSTRAINT FK_FACT_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTDIM,
		CONSTRAINT FK_FACT_EMPLOYEE FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEEDIM,
		CONSTRAINT FK_FACT_TIME FOREIGN KEY (TIME_ID) REFERENCES TIMEDIM;

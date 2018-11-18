--CALEB HAYDEN

--A10BC

--1. What are the top 5 products in terms of sales (total quantity * price)?

select top 5 PRODUCT_ID, SUM (QUANTITY *PRICE) AS  TOTAL_SALES
from FACT
GROUP BY PRODUCT_ID
ORDER BY TOTAL_SALES DESC

--2. List the names of employees who have sold the most products in terms of amount of sales (total of quantity * price)

select top 5 E.EMPLOYEE_ID, E.EMP_LNAME, E.EMP_FNAME, SUM (F.QUANTITY * F.PRICE) AS TOTAL_SALES
from EMPLOYEEDIM E inner join FACT F on E.EMPLOYEE_ID = F.EMPLOYEE_ID
GROUP BY E.EMPLOYEE_ID, E.EMP_LNAME, E.EMP_FNAME
ORDER BY TOTAL_SALES DESC

--3. List the total amount of sales by customer city and brand name.

select C.CUST_CITY, P.BRAND_NAME, SUM (QUANTITY *PRICE) AS  TOTAL_SALES
FROM CUSTOMERDIM C inner join FACT F on C.CUSTOMER_ID = F.CUSTOMER_ID inner join PRODUCTDIM P on F.PRODUCT_ID = P.PRODUCT_ID
GROUP BY CUST_CITY, BRAND_NAME
ORDER BY TOTAL_SALES DESC

--4. List the customer names of customers and the top 5 products each of these customers have bought. 

select C.CUST_LNAME, C.CUST_FNAME, P.BRAND_NAME, P.PRODUCT_ID, SUM (QUANTITY *PRICE) AS  TOTAL_SALES
FROM FACT F inner join CUSTOMERDIM C on F.CUSTOMER_ID = C.CUSTOMER_ID inner join PRODUCTDIM P on F.PRODUCT_ID = P.PRODUCT_ID
where P.PRODUCT_ID IN 
(select top 5 PRODUCT_ID
FROM FACT
GROUP BY PRODUCT_ID
ORDER BY SUM (QUANTITY *PRICE) DESC
)
GROUP BY C.CUST_LNAME, C.CUST_FNAME, P. BRAND_NAME,P.PRODUCT_ID
ORDER BY C.CUST_LNAME, TOTAL_SALES DESC
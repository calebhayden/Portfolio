--A9 
--Caleb Hayden

--PART 2 


CREATE TRIGGER A9
ON LGLINE
AFTER INSERT,DELETE,UPDATE
AS
BEGIN

DECLARE @INV_NUM CHAR(4)
DECLARE @TOTAL NUMERIC(38)

--INSERT
IF(EXISTS(SELECT * FROM INSERTED))
BEGIN 
DECLARE INSERTED_CURSOR CURSOR FOR
SELECT INV_NUM,SUM(LINE_QTY*LINE_PRICE) AS TOTAL
FROM INSERTED
GROUP BY INV_NUM

OPEN INSERTED_CURSOR
FETCH NEXT FROM INSERTED_CURSOR
INTO @INV_NUM, @TOTAL
WHILE (@@FETCH_STATUS = 0)
BEGIN
	UPDATE LGINVOICE
	SET  inv_total =INV_TOTAL + @TOTAL
	WHERE inv_num = inv_num
	FETCH NEXT FROM INSERTED_CURSOR
	INTO @INV_NUM, @TOTAL
END
CLOSE INSERTED_CURSOR
DEALLOCATE INSERTED_CURSOR
END

--DELETE
ELSE IF(EXISTS(SELECT * FROM DELETED) AND NOT EXISTS
(SELECT * FROM INSERTED))
BEGIN 
DECLARE DELETED_CURSOR CURSOR FOR
SELECT INV_NUM, SUM(LINE_PRICE) AS TOTAL
from DELETED
GROUP BY INV_NUM

OPEN DELETED_CURSOR
FETCH NEXT FROM DELETED_CURSOR
INTO @inv_num, @TOTAL
WHILE (@@FETCH_STATUS = 0)
BEGIN 
UPDATE LGINVOICE
SET inv_total = INV_TOTAL + @TOTAL
WHERE inv_num = inv_num
FETCH NEXT FROM DELETED_CURSOR
INTO @INV_NUM, @TOTAL
END
CLOSE DELETED_CURSOR
DEALLOCATE DELETED_CURSOR
END

--UPDATE
ELSE IF(EXISTS(SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED))
BEGIN
DECLARE UPDATED_CURSOR CURSOR FOR
SELECT I.INV_NUM, SUM(I.LINE_QTY*I.LINE_PRICE) - (D.LINE_QTY * D.LINE_PRICE) AS TOTAL
FROM DELETED D INNER JOIN INSERTED I ON D.INV_NUM = I.INV_NUM
WHILE (@@FETCH_STATUS = 0)

BEGIN 
UPDATE LGINVOICE
SET INV_TOTAL = INV_TOTAL + @TOTAL
WHERE INV_NUM = INV_NUM
FETCH NEXT UPDATED_CURSOR INTO @INV_NUM, @TOTAL
END
CLOSE UPDATED_CURSOR
DEALLOCATE UPDATED_CURSOR
END

END



--PART 3
Select *
From LGINVOICE

Select *
From LGINVOICE
WHERE INV_NUM IN (110,111,112,113,114)

--create temp table
Select * INTO TEMPORARY
FROM LGINVOICE
WHERE INV_NUM IN (110,111,112,113,114)

--insert
INSERT INTO LGLINE
SELECT *
FROM TEMPORARY

--delete
DELETE 
FROM LGLINE
WHERE INV_NUM IN (110,111,112,113,114)

--update
UPDATE LGLINE
SET LINE_QTY = LINE_QTY + 4
WHERE INV_NUM IN (110,111,112,113,114)




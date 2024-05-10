select * from sales_dataset_rfm_prj
-- câu 1 
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN priceeach  type numeric USING(priceeach::numeric)

-- câu 2
	SELECT ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE
	FROM sales_dataset_rfm_prj
	WHERE (ORDERNUMBER is null or ORDERNUMBER = '')
	AND  (QUANTITYORDERED is null or QUANTITYORDERED = '')
	AND   (PRICEEACH is null or PRICEEACH = '')
	AND  (ORDERLINENUMBER is null or ORDERLINENUMBER = '')
	AND  ( SALES is null or SALES = '')
	AND  ( ORDERDATE is null or ORDERDATE = '')
	
--câu 3
	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN CONTACTLASTNAME VARCHAR(50)
	UPDATE sales_dataset_rfm_prj
	SET CONTACTLASTNAME = substring(contactfullname, 1 , POSITION('-' IN contactfullname)-1)

	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN CONTACTFIRSTNAME VARCHAR(50)
	UPDATE sales_dataset_rfm_prj
	SET CONTACTFIRSTNAME = substring(contactfullname, POSITION('-' IN contactfullname)+1, LENGTH(contactfullname))

--câu 4

	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN QTR_ID numeric
	
	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN MONTH_ID numeric

	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN YEAR_ID numeric

	SET datestyle = 'iso,mdy';  
	ALTER TABLE sales_dataset_rfm_prj
	ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)
	
	UPDATE sales_dataset_rfm_prj
	SET QTR_ID  = EXTRACT(QUARTER from orderdate)
	UPDATE sales_dataset_rfm_prj
	SET MONTH_ID
	UPDATE sales_dataset_rfm_prj
	SET  YEAR_ID = EXTRACT(YEAR from orderdate)

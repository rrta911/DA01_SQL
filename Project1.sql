select * from sales_dataset_rfm_prj
-- câu 1 
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN priceeach  type numeric USING(priceeach::numeric)

	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN priceeach  type numeric USING(priceeach::numeric)
	
		
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN orderlinenumber  type decimal USING(priceeach::decimal)
	
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN sales  type numeric USING(priceeach::numeric)
	
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN msrp  type numeric USING(priceeach::numeric)
	
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN postalcode  type numeric USING(priceeach::numeric)

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

--câu 5 
	WITH twt_min_max_value AS(
	SELECT Q1 - 1.5*IQR min_value,
	Q3 + 1.5*IQR max_value
	FROM(
	select 
	percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) Q1,
	percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) Q3,
	percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) - percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) IQR 
	from sales_dataset_rfm_prj) as a)
	--tien hanh loc outlier 
	/*select * from sales_dataset_rfm_prj
	where QUANTITYORDERED < (select min_value from twt_min_max_value)
	or QUANTITYORDERED > (select max_value from twt_min_max_value)*/
		-- delete data 
		DELETE FROM sales_dataset_rfm_prj
		WHERE QUANTITYORDERED IN (select QUANTITYORDERED from sales_dataset_rfm_prj
	where QUANTITYORDERED < (select min_value from twt_min_max_value)
	or QUANTITYORDERED > (select max_value from twt_min_max_value))
--cach 2 
	-- z-score = (x-avg)/stddev ( viet cte tim truoc)
	with cte as
(
	select QUANTITYORDERED,
		(select avg(QUANTITYORDERED) 
		from sales_dataset_rfm_prj) as avg, 
		(select stddev(QUANTITYORDERED) 
		from sales_dataset_rfm_prj) as stddev
	from sales_dataset_rfm_prj ) 
	--loc outlier
, TWT_outlier as(
select  QUANTITYORDERED, (QUANTITYORDERED-avg)/stddev as z_score
from cte
where abs((QUANTITYORDERED-avg)/stddev) >3)
	--update
UPDATE sales_dataset_rfm_prj
SET QUANTITYORDERED=(select avg(QUANTITYORDERED)
from sales_dataset_rfm_prj)
WHERE QUANTITYORDERED IN (select QUANTITYORDERED from twt_outlier)


--câu 6 

ALTER TABLE sales_dataset_rfm_prj
RENAME TO SALES_DATASET_RFM_PRJ_CLEAN

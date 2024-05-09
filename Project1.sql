select * from sales_dataset_rfm_prj
-- câu 1 
	ALTER TABLE sales_dataset_rfm_prj
	alter COLUMN priceeach  type numeric USING(priceeach::numeric)
	
--câu 2 
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
	UPDATE sales_dataset_rfm_prj
	SET QTR_ID 
	
	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN MONTH_ID numeric
	UPDATE sales_dataset_rfm_prj
	SET MONTH_ID = EXTRACT(MONTH from orderdate::date)
	  SET datestyle = dmy;
	ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN YEAR_ID numeric
	UPDATE sales_dataset_rfm_prj
	SET  YEAR_ID

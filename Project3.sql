--baitap 1 
WITH revenue_cte as(
SELECT *,
quantityordered * priceeach as revenue 
FROM  public.sales_dataset_rfm_prj_clean )

SELECT  productline, year_id, dealsize,
SUM(revenue) revenue
FROM revenue_cte
GROUP BY  productline, year_id, dealsize

--baitap 2 
WITH revenue_cte as(
SELECT *,
quantityordered * priceeach as revenue 
FROM  public.sales_dataset_rfm_prj_clean )
,revenue_month AS
(SELECT   month_id, year_id, ordernumber,
SUM(revenue)  revenue
FROM revenue_cte 
GROUP BY year_id, month_id, ordernumber
)
SELECT month_id, revenue, ordernumber
FROM revenue_month
WHERE revenue IN
(SELECT 
MAX(revenue)
FROM revenue_month
GROUP BY year_id)

--baitap 3 

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
WHERE month_id =11 AND revenue IN (SELECT max(revenue) FROM revenue_month  GROUP BY month_id)

--baitap 4 
  select year_id,productline,ORDER_NUMBER, Rankk from
(select year_id,
 	productline, 
 	sum(sales) as REVENUE,count(ordernumber) as ORDER_NUMBER, 
 	rank() over(partition by year_id order by sum(sales),count(ordernumber) ) Rankk
 from public.sales_dataset_rfm_prj_clean
 WHERE country = 'UK'
group by year_id, productline) as t
where Rankk =1

--baitap 5 
/* B1: Tính giá trị R-F-M*/
with customer_rfm as(
select 
	customername,
	current_date - Max(orderdate) R,
	count(distinct ordernumber) F,
	sum(sales) as M 
from public.sales_dataset_rfm_prj_clean
GROUP BY customername),

/* B2: Phân nhóm khách hàng thành các khoảng 1 -5 */
	 rfm_score as(
	select customername,
	ntile(5) OVER(ORDER BY R DESC) R_score,
	ntile(5) OVER(ORDER BY F DESC) F_score,
	ntile(5) OVER(ORDER BY M DESC) M_score
	from customer_rfm)

/* B3: Phân nhóm theo tổ hợp */
	,rfm_final as(
	SELECT customername,
	CAST(R_score AS varchar) || CAST(F_score AS varchar) || CAST(M_score AS varchar) as answer
	FROM rfm_score )
	
	SELECT segment, customername from (
	SELECT *
	FROM rfm_final a
	JOIN public.segment_score b on a.answer = b.scores)a
	WHERE segment IN ('Potential Loyalist', 'Promising')
	GROUP BY segment,customername
	

	

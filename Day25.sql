/* Bước 1: Tính giá trị R-F-M*/

select * from customer;
select * from sales;
select * from segment_score;

WITH customer_rfm as (
  select 
a.customer_id
  current_date - MAX(order_date) as R,
  count(distinct order_id) as F, 
  sum(sales) as M
  from customer a 
  JOIN sales b ON a.customer_id=b.customer_id
  group by a.customer_id) 

/*Bước 2: Chia các giá trị thành các khoảng trên thang điểm 1 -5*/
,rfm_score as(
select customer_id,
  ntile(5) OVER(ORDER BY R DESC) R-score
  ntile(5) OVER(ORDER BY F DESC) F-score
  ntile(5) OVER(ORDER BY M DESC) M-score
from customer_rfm)

/*Bước 3: Phân nhóm theo 125 tổ hợp R-F-M*/
, rfm_final as(
SELECT customer_id,
CAST(R-score AS varchar) || CAST(F-score AS varchar) || CAST(M-score as varchar) as rfm_score
FROM rfm_score)

SELECT segment, count(*) from (
SELECT a.customer_id, b.segment 
FROM rfm_final  a
JOIN segment_score b ON a.rfm_score = B.score ) as a
ORDER BY segment 
ORDER BY count(*)

/*Bước 4: Trực quan phân tích RFM

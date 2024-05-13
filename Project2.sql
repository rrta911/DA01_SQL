-- ad-hoc 1, số lượng đơn hàng và số lượng khách hàng mỗi tháng   
select COUNT(user_id)  total_user , COUNT(order_id) total_order
,FORMAT_DATE('%Y-%m', created_at) as month_year 
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete' and (created_at BETWEEN '2019-01-01' AND '2022-04-01') 
GROUP BY FORMAT_DATE('%Y-%m',created_at)
ORDER BY month_year DESC

-- insight: số lượng khách hàng và đơn hàng tăng mỗi tháng ==> strategy của công ty đang có hiệu quả 

--ad-hoc 2
select COUNT(a.user_id)  distinct_users , SUM(b.sale_price)/COUNT(a.order_id) average_order_value
 , FORMAT_DATE('%Y-%m',a.created_at ) as month_year 
from bigquery-public-data.thelook_ecommerce.orders a
JOIN bigquery-public-data.thelook_ecommerce.order_items b ON  a.order_id= b.order_id
where a.created_at BETWEEN '2019-01-01' AND '2022-04-01' 
GROUP BY  FORMAT_DATE('%Y-%m',a.created_at )
ORDER BY month_year DESC

-- insight: số mặc dù số lượng khách hàng tăng, nhưng số lượng đơn hàng và giá trị trung bình đơn hàng không cao ==> cần nhìn vào sản phẩm 

Hint: Giá trị đơn hàng lấy trường sale_price từ bảng order_items

--ad-hoc 3 Nhóm khách hàng theo độ tuổi
--Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
--Hint: Sử dụng UNION các KH tuổi trẻ nhất với các KH tuổi trẻ nhất 


WITH CTE AS(
SELECT first_name, last_name, gender, age,"yongest" as tag
FROM(
  SELECT  first_name, last_name, gender, age,
  DENSE_RANK() OVER(PARTITION BY gender ORDER BY age) young
  FROM bigquery-public-data.thelook_ecommerce.users ) A 
where young =1 
  UNION ALL
SELECT first_name, last_name, gender, age,"oldest" as tag
FROM(
  SELECT  first_name, last_name, gender, age,
  DENSE_RANK() OVER(PARTITION BY gender ORDER BY age DESC) OLD
  FROM bigquery-public-data.thelook_ecommerce.users ) A 
where old = 1)

SELECT 
    COUNT(CASE WHEN tag = "youngest" then 1 ELSE 0 END) as youngg,
    COUNT(CASE WHEN tag = "oldest" then 1 ELSE 0 END) oldd
  FROM CTE

--INSIGHT: số lượng người nhỏ tuổi nhất và lớn tuổi nhất là bằng nhau (3284), khách hàng nhỏ tuổi nhất là 12 tuổi, khách hàng lớn tuổi nhất là 70 tuổi

4.Top 5 sản phẩm mỗi tháng.
Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).
Hint: Sử dụng hàm dense_rank()

  WITH revenue_a AS (
select FORMAT_DATE('%Y-%m',a.created_at ) as month_year,
  SUM(sale_price) sales,
  SUM(cost) cost,
 (SUM(sale_price) -  SUM(cost)) profit,
 b.id product_id, b.name product_name
from bigquery-public-data.thelook_ecommerce.order_items a
JOIN bigquery-public-data.thelook_ecommerce.products b ON  a.product_id= b.id
GROUP BY month_year,b.id, b.name
ORDER BY   profit DESC) 
SELECT month_year, product_id, product_name, sales, cost, profit,rank_per_month
FROM(
SELECT month_year, product_id, product_name, sales, cost, profit,
DENSE_RANK() OVER(PARTITION BY month_year ORDER BY  profit DESC) rank_per_month
FROM revenue_a) 
WHERE rank_per_month IN (1,2,3,4,5)
ORDER BY rank_per_month ASC

5. Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục 
select 
FORMAT_DATE('%Y-%m-%d',a.created_at ) as dates ,
b.category product_categories, 
SUM(a.sale_price) revenue
from bigquery-public-data.thelook_ecommerce.products b
JOIN bigquery-public-data.thelook_ecommerce.order_items a ON  a.order_id= b.id
where a.created_at BETWEEN '2022-01-15' AND '2022-04-15' 
GROUP BY  FORMAT_DATE('%Y-%m-%d',a.created_at ), b.category
ORDER BY dates DESC

II. 
 --dựng dashboard 
 

SELECT *, round(cast((TPV - lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPV) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Revenue_growth,
round(cast((TPO - lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month))
      /lag(TPO) OVER(PARTITION BY Product_category ORDER BY Year, Month) as Decimal)*100.00,2) || '%'
       as Order_growth,
Total_cost,
round(TPV - Total_cost,2) as Total_profit,
round((TPV - Total_cost)/Total_cost,2) as Profit_to_cost_ratio
FROM (
  select 
FORMAT_DATE('%Y-%m',a.created_at ) as month,
FORMAT_DATE('%Y',a.created_at ) as Year,
b.category Product_category,
round(sum(c.sale_price),2) TPV,
COUNT (c.order_id) TPO,
round(sum(b.cost),2) as Total_cost
from bigquery-public-data.thelook_ecommerce.orders a 
JOIN bigquery-public-data.thelook_ecommerce.products b ON a.order_id = b.id 
JOIN bigquery-public-data.thelook_ecommerce.order_items c ON b.id = c.id
GROUP BY month, year ,Product_category
ORDER BY month
) t
Order by Product_category, Year, Month

2. 

WITH t1 AS(
  SELECT b.created_at, b.sale_price,b.user_id
  FROM bigquery-public-data.thelook_ecommerce.users a 
  JOIN bigquery-public-data.thelook_ecommerce.order_items b ON a.id = b.user_id 
)

 --- begin analyst 
--select * from online_retail_main
,online_retail_index as(
SELECT 
  *,
	FORMAT_DATE('%Y-%m-%d',created_at) as cohort_date,
	(FORMAT_DATE('%Y', created_at)- FORMAT_DATE('%Y', first_purchase_date))*12
	+(FORMAT_DATE('%m', created_at)-FORMAT_DATE('%m', first_purchase_date))+1 as indexs
FROM(
	SELECT user_id,
	  sale_price AS amount,
MIN(created_at) over(PARTITION BY user_id) as first_purchase_date,
created_at
from t1
) a)
,xxx as(
SELECT 
cohort_date,
index,
count(distinct user_id) as cnt,
sum(amount) as revenue
from online_retail_index
group by cohort_date, index)

--- customer_cohort
,customer_cohort as (
select 
cohort_date,
sum(case when index=1 then cnt else 0 end ) as m1,
sum(case when index=2 then cnt else 0 end ) as m2,
sum(case when index=3 then cnt else 0 end ) as m3,
sum(case when index=4 then cnt else 0 end ) as m4,
sum(case when index=5 then cnt else 0 end ) as m5,
sum(case when index=6 then cnt else 0 end ) as m6,
sum(case when index=7 then cnt else 0 end ) as m7,
sum(case when index=8 then cnt else 0 end ) as m8,
sum(case when index=9 then cnt else 0 end ) as m9,
sum(case when index=10 then cnt else 0 end ) as m10,
sum(case when index=11 then cnt else 0 end ) as m11,
sum(case when index=12 then cnt else 0 end ) as m12,
sum(case when index=13 then cnt else 0 end ) as m13
from xxx
group by cohort_date
order by cohort_date)
-- retention cohort
select
cohort_date,
(100-round(100.00* m1/m1,2))||'%' as m1,
(100-round(100.00* m2/m1,2))|| '%' as m2,
(100-round(100.00* m3/m1,2)) || '%' as m3,
round(100.00* m4/m1,2) || '%' as m4,
round(100.00* m5/m1,2) || '%' as m5,
round(100.00* m6/m1,2) || '%' as m6,
round(100.00* m7/m1,2) || '%' as m7,
round(100.00* m8/m1,2) || '%' as m8,
round(100.00* m9/m1,2) || '%' as m9,
round(100.00* m10/m1,2) || '%' as m10,
round(100.00* m11/m1,2) || '%' as m11,
round(100.00* m12/m1,2) || '%' as m12,
round(100.00* m13/m1,2) || '%' as m13
from customer_cohort
-- churn cohort

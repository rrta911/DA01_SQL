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



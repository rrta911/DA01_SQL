-- ad-hoc 1, số lượng đơn hàng và số lượng khách hàng mỗi tháng   
select COUNT(user_id)  total_user , COUNT(order_id) total_order
, EXTRACT(YEAR FROM created_at) || '-'|| EXTRACT(MONTH FROM created_at) as month_year 
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete' and (created_at BETWEEN '2019-01-01' AND '2022-04-01') 
GROUP BY EXTRACT(YEAR FROM created_at) || '-'|| EXTRACT(MONTH FROM created_at)
ORDER BY month_year DESC

-- insight: số lượng khách hàng và đơn hàng tăng mỗi tháng ==> strategy của công ty đang có hiệu quả 

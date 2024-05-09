--baitap 1 
  with first_orders AS (
        SELECT MIN(order_date) min, customer_id
        FROM delivery
        GROUP BY customer_id ),
like_day AS (
        SELECT customer_id, order_date
        FROM delivery
        WHERE order_date = customer_pref_delivery_date 
)
SELECT COUNT(*) / (SELECT COUNT( DISTINCT customer_id) from delivery )*100 as immediate_percentage
FROM first_orders a 
JOIN like_day b ON a.customer_id = b.customer_id AND a.min = b.order_date


--baitap 2 

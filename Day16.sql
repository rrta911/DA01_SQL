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
# Write your MySQL query statement below
/* output: fraction: count(again)/ count(number player) */
WITH CTE AS (
SELECT COUNT(*) cnt_again
FROM(
SELECT event_date, 
event_date-LEAD(event_date) OVER(PARTITION BY player_id) a
FROM activity ) t  
where abs(a) = 1)
SELECT ROUND(cnt_again/(
SELECT COUNT(DISTINCT player_id)
FROM ACTIVITY 
),2) fraction
FROM CTE

--baitap 3

# Write your MySQL query statement below
/* OUTPUT id, student, swap student, if count(*)%2 = 1 then last student do not be swaped */ 
SELECT 
    CASE 
        WHEN id = (select MAX(id) FROM seat) AND id % 2 = 1
            THEN id
        WHEN id % 2 = 1 
            THEN  id + 1 
        ELSE id-1
        END AS id, student 
FROM seat
ORDER BY id

--baitap 4 

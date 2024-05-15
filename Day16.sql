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


--baitap 5
SELECT ROUND(SUM(tiv_2016),2) tiv_2016
FROM (
SELECT tiv_2015, tiv_2016,
COUNT(*) OVER(PARTITION BY tiv_2015) cnt,
COUNT(*) OVER(PARTITION BY lat,lon) rankk
FROM Insurance ) a
WHERE  cnt >1 AND rankk = 1

--baitap 6 

# Write your MySQL query statement below
/* output: department, employee, salary 
DEMAND: who ear most in EACH departments , find top three (dense_rank) over(partition by department)
*/
WITH CTE as(
SELECT b.name, a.name Employee, a.salary Salary,
DENSE_RANK() OVER( PARTITION BY a.departmentID ORDER BY a.salary DESC) r
FROM employee a
JOIN Department b ON a.departmentID = b.id
)
SELECT name as Department, Employee, Salary
FROM CTE  
WHERE r IN (1,2,3)
    
--baitap 7
# Write your MySQL query statement below
/* output: Turn, ID, name, weight, total weight
S1: order by turn, 
*/
# Write your MySQL query statement below
/* output: Turn, ID, name, weight, total weight
S1: order by turn, */

With CTE AS (
SELECT turn Turn, person_id ID, person_name Name, weight Weight , 
SUM(weight) OVER(ORDER BY turn ASC) Total
FROM Queue)
SELECT Name person_name
FROM CTE 
WHERE Total <=1000
ORDER BY TURN desc
LIMIT 1

--baitap 8 

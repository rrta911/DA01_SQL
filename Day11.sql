--baitap 1 
SELECT b.continent, FLOOR(AVG(a.population))
FROM CITY a
INNER JOIN COUNTRY b ON a.countrycode = b.code 
GROUP BY b.continent

--baitap 2 
SELECT ROUND(CAST(COUNT(b.email_id) AS DECIMAL)/ COUNT(DISTINCT a.email_id),2) activation_rate
FROM emails a
LEFT JOIN texts b ON a.email_id = b.email_id
                  AND b.signup_action = 'Confirmed'

--baitap 3 
  SELECT 
  b.age_bucket,
  ROUND(100.0*SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)/ SUM(a.time_spent),2) send_perc,
  ROUND(100.0*SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)/ SUM(a.time_spent),2) open_perc
  FROM activities a
  INNER JOIN age_breakdown b ON a.user_id = b.user_id
                            WHERE a.activity_type IN ('send', 'open')
  GROUP BY b.age_bucket
--baitap 4 
  SELECT a.customer_id 
  FROM customer_contracts  a 
  LEFT JOIN products b 
  ON a.product_id = b.product_id 
  GROUP BY  a.customer_id 
  HAVING COUNT(DISTINCT product_category) = 3;

--baitap 5
    SELECT  mng.employee_id, mng.name, COUNT(emp.employee_id) reports_count, ROUND(AVG(emp.age)) as average_age
  FROM employees emp
  JOIN employees mng ON emp.reports_to = mng.employee_id
  GROUP BY employee_id
  ORDER BY employee_id

--baitap 6 
MID-COURSE 

  baitap1: 
  SELECT * 

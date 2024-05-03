--baitap 1 
  with a AS (
  SELECT company_id, COUNT(company_id) duplicate_companies
  FROM job_listings
  GROUP BY company_id)
  SELECT COUNT(duplicate_companies)
  FROM a  
  WHERE duplicate_companies >1 

 --baitap 2 
  WITH CTE1 AS (SELECT Category, product, spend as total_spend
FROM product_spend 
WHERE category = 'appliance'
ORDER BY spend DESC
LIMIT 2 ),

CTE2 AS(SELECT Category, product, spend as total_spend
FROM product_spend 
WHERE category = 'electronics'
ORDER BY spend DESC
LIMIT 2 )

SELECT Category, product,  total_spend FROM CTE1
UNION ALL
SELECT Category, product, total_spend FROM CTE2


--baitap 3
  WITH countt AS(
  SELECT COUNT(case_id) policy_holder_count, policy_holder_id  
  FROM callers
  GROUP BY policy_holder_id)
  SELECT COUNT(policy_holder_count) policy_holder_count
  FROM countt
  WHERE policy_holder_count >=3

--baitap 4 
  WITH page_count AS(
  SELECT COUNT(a.page_id) countt, a.page_id
  FROM pages a
  LEFT JOIN page_likes b ON a.page_id = b.page_id
  WHERE b.user_id IS NULL
  GROUP BY a.page_id)

  SELECT page_id
  FROM page_count 
  WHERE countt >=1

--baitap 5
  WITH 
  curr_month AS (
    SELECT *
    FROM user_actions
    WHERE event_type IN ('sign-in','like','commnet')
      AND  EXTRACT(month from event_date) = 7 ),
      
  last_month AS (
    SELECT *
    FROM user_actions
    WHERE event_type IN ('sign-in','like','commnet')
      AND  EXTRACT(month from event_date) = 6 )
    
    SELECT EXTRACT(MONTH FROM a.event_date) AS month, COUNT(DISTINCT a.user_id) monthly_active_users
    FROM curr_month a
    JOIN last_month b ON a.user_id = b.user_id
    GROUP BY month
--baitap 6 
SELECT  SUBSTR(trans_date,1,7) as month, country, count(id) as trans_count, 
        SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count, 
        SUM(amount) as trans_total_amount, 
        SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount
FROM Transactions
GROUP BY month, country

--baitap 7 
WITH first_year1 AS (
        SELECT product_id, MIN(year) first_year
        FROM sales
        GROUP by product_id
)

  SELECT b.product_id, b.first_year, a.quantity, a.price
  FROM sales a
  JOIN first_year1 b ON a.product_id = b.product_id
  WHERE a.year = b.first_year

--baitap 8 
  SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(product_key)
    FROM Product
)

--baitap 9  
  SELECT b.employee_id
  FROM employees a
  JOIN employees b ON a.manager_id= b.employee_id
  WHERE a.salary <30000

--baitap 10 
    with a AS (
SELECT company_id, COUNT(company_id) duplicate_companies
FROM job_listings
GROUP BY company_id)

SELECT COUNT(duplicate_companies)
FROM a  
WHERE duplicate_companies >1 

--baitap 11
  WITH 
  rating_t AS (SELECT name, COUNT(*)
    FROM users a
    JOIN MovieRating b ON a.user_id = b.user_id),

 avg_t AS (SELECT title
    FROM Movies a
    JOIN MovieRating b ON a.movie_id = b.movie_id AND b.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY title
    order by avg(rating) desc, title ASC
    LIMIT 1)
    SELECT name results FROM rating_t 
    UNION ALL
    SELECT title FROM avg_t
--baitap 12
  WITH CTE AS (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION  ALL
    SELECT accepter_id AS id
    FROM RequestAccepted
)
    SELECT id, 
            COUNT(id) AS num
    FROM CTE 
    GROUP BY id
    ORDER BY COUNT(id) DESC
    LIMIT 1  

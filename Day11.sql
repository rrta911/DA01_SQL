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
      SELECT p.product_name, SUM(o.unit)  unit 
  FROM products p
  JOIN orders o 
  ON p.product_id = o.product_id 
    WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
  GROUP BY p.product_name
  HAVING SUM(o.unit) >=100
--baitap 7 
        SELECT p.page_id
  FROM pages p
  LEFT JOIN page_likes l 
  ON p.page_id = l.page_id
  GROUP BY(p.page_id)
  HAVING COUNT(l.page_id) = 0
      
MID-COURSE 

--baitap1: 
  SELECT replacement_cost
  FROM public.film
  ORDER BY replacement_cost ASC;

--baitap 2
  SELECT 
	SUM(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0 END) low
	--CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN replacement_cost ELSE 0 END medium,
	--CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN replacement_cost ELSE 0 END high
  FROM film

--baitap 3 
  SELECT f.title, f.length, c.name
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id AND c.name IN ('Drama', 'Sports')
  ORDER BY f.length DESC;

--baitap 4 
  SELECT f.title, f.length, c.name
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id AND c.name IN ('Drama', 'Sports')
  ORDER BY f.length DESC;

--baitap 5 
  SELECT CONCAT(ac.first_name, ' ', ac.last_name), COUNT(f.title) 
  FROM public.actor ac 
  JOIN film_actor fc ON ac.actor_id = fc.actor_id
  JOIN film f ON f.film_id = fc.film_id
  GROUP BY ac.first_name, ac.last_name
  ORDER BY COUNT(f.title) DESC

--baitap 6
  SELECT COUNT(*)
  FROM address a 
  LEFT JOIN customer c ON a.address_id = c.address_id WHERE c.address_id IS NULL

--baitap 7 
  SELECT city || ':', SUM(p.amount)
  FROM city as ci
  LEFT JOIN address ad ON ci.city_id = ad.city_id
  LEFT JOIN customer c ON ad.address_id = c.address_id 
  LEFT JOIN payment p ON c.customer_id = p.customer_id 
  GROUP BY city
  ORDER BY SUM(p.amount) DESC

--baitap 8 
  SELECT co.country || ',' || ci.city, SUM(p.amount)
FROM city as ci
LEFT JOIN country co ON ci.country_id = co.country_id
LEFT JOIN address ad ON ci.city_id = ad.city_id
LEFT JOIN customer c ON ad.address_id = c.address_id 
LEFT JOIN payment p ON c.customer_id = p.customer_id 
WHERE country = 'United States'
GROUP BY co.country, city
ORDER BY SUM(p.amount) DESC


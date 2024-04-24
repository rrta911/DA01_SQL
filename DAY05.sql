--baitap 1
  SELECT city
  FROM STATION
  WHERE id%2 = 0
  GROUP BY city

--baitap 2
  SELECT COUNT(city) - COUNT(DISTINCT city)
  FROM station;

--baitap 3

--baitap 4
  SELECT ROUND(CAST(SUM(item_count * order_occurrences)/ SUM(order_occurrences) AS DECIMAL),1)
  FROM items_per_order;

--baitap 5
  SELECT candidate_id 
  FROM candidates
  WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
  GROUP BY candidate_id
  HAVING count(skill) =3;

--baitap 6
  SELECT user_id, DATE(MAX(post_date)) - DATE(MIN(post_date)) days_between
  FROM posts
  WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
  GROUP BY user_id 
  HAVING COUNT(post_date) >=2;
--baitap 7 
  SELECT card_name, MAX(issued_amount) - MIN(issued_amount) as difference
  FROM monthly_cards_issued
  GROUP BY card_name
  ORDER BY difference DESC ;
--baitap 8 
  SELECT manufacturer, COUNT(drug) as drug_count, ABS(SUM(cogs-total_sales)) as total_loss
  FROM pharmacy_sales
  WHERE cogs > total_sales
  GROUP BY manufacturer
  ORDER BY total_loss DESC;

--baitap 9 
  SELECT *
  FROM cinema
  WHERE id%2 = 1 AND description != 'boring'
  ORDER BY rating DESC;

--baitap 10
  SELECT DISTINCT teacher_id, COUNT(DISTINCT subject_id) cnt
  FROM Teacher
  GROUP BY teacher_id

--baitap 11
  SELECT user_id, COUNT(user_id) followers_count
  FROM Followers
  GROUP BY user_id

--baitap 12
  SELECT class
  FROM courses 
  GROUP BY class
  HAVING COUNT(student) >= 5

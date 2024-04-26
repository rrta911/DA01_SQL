--baitap 1
  SELECT name
  FROM students
  WHERE Marks > 75
  ORDER BY RIGHT(name,3), id ASC

--baitap 2
  SELECT user_id, CONCAT(UPPER(LEFT(name,1)), LOWER(RIGHT(name, LENGTH(name) -1 ))) name
  FROM Users
  ORDER BY user_id

--baitap 3 
  SELECT manufacturer, '$'|| round(SUM(total_sales)/1000000,0) || ' ' || 'million' sale
  FROM pharmacy_sales
  GROUP BY manufacturer
  ORDER BY SUM(total_sales) DESC, manufacturer ;

--baitap 4 
  SELECT 
  EXTRACT(month FROM submit_date) as mth, 
  product_id,
  round(avg(stars),2) as avg_stars
  FROM reviews
  GROUP BY mth, product_id
  ORDER BY mth, product_id;

--baitap 5 
  SELECT DISTINCT sender_id, COUNT(sender_id) message_count
  FROM messages
  WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31'
  GROUP BY sender_id
  ORDER BY COUNT(sender_id) DESC
  LIMIT 2;

--baitap 6 
  SELECT tweet_id
  FROM Tweets
  WHERE LENGTH(content) > 15
  LIMIT 1; 

--baitap 7
  SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
  FROM Activity
  WHERE (activity_date > "2019-06-27" AND activity_date <= "2019-07-27")
  GROUP BY activity_date;

  
--baitap 8 
  select COUNT(DISTINCT id) 
  from employees
  WHERE joining_date BETWEEN '2022-01-01' AND '2022-07-01' ;

--baitap 9  
  select POSITION('a' IN first_name)
  from worker
  WHERE first_name ='Amitah';

--baitap 10   
  select substring(title FROM length(winery) +2  FOR 4)
  from winemag_p2
  where country = 'Macedonia'

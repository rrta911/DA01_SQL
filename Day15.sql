--baitap 1 
  WITH CTE AS (SELECT EXTRACT(year from transaction_date) as year, product_id,
spend curr_year_spend,
LAG(spend) OVER( PARTITION BY product_id ORDER BY  EXTRACT(year from transaction_date), product_id) prev_year_spend
FROM user_transactions
GROUP BY product_id, year, spend)

SELECT year, product_id, curr_year_spend, prev_year_spend,
ROUND(((curr_year_spend - prev_year_spend) / prev_year_spend)*100.0,2) yoy_rate
FROM cte

--baitap 2 
  WITH CTE AS (SELECT card_name, issued_amount, issue_month, issue_year,
RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month ) as num
FROM monthly_cards_issued
order by card_name, issue_year, issue_month	)

SELECT card_name, issued_amount
FROM CTE 
WHERE num =1 
ORDER BY issued_amount DESC
;

--baitap 3 
WITH CTE AS (SELECT *,
 ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) A 
FROM transactions)

SELECT user_id, spend, transaction_date
FROM CTE 
WHERE A = 3

--baitap 4 
  WITH latest_transactions_cte AS ( SELECT 
  transaction_date, 
  user_id, 
  product_id,
  RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) as rankk
  FROM user_transactions)
  
  SELECT  transaction_date, 
  user_id,
  COUNT(product_id) purschase_count
  FROM latest_transactions_cte 
  WHERE rankk = 1
  GROUP BY transaction_date, user_id
  ORDER BY transaction_date

--baitap 5

--baitap 6
/* output: payment_count: 
 + same amount
 + same merchant id 
 + within 10 minutes --> lead - curr */ 
WITH CTE AS(SELECT 
transaction_id
  merchant_id, 
  credit_card_id, 
  amount, 
  transaction_timestamp,
EXTRACT(EPOCH FROM transaction_timestamp - 
    LAG(transaction_timestamp) OVER(
      PARTITION BY merchant_id, credit_card_id, amount 
      ORDER BY transaction_timestamp))/60 AS dif
      FROM transactions)
SELECT COUNT(merchant_id) AS payment_count
FROM CTE
WHERE dif <= 10;

--baitap 7 
/* TOP TWO highest products each category 
year 2022, 
OUTput: category, product, *total spend 
1. Total spend for each category 
2. MAIN QUERY */
WITH top_two AS (
SELECT 
  category, 
  product, 
  SUM(spend) total_spend,
  RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as r
  FROM product_spend
  WHERE EXTRACT (YEAR FROM transaction_date) = 2022
  GROUP BY category, product )
  
  SELECT 
  category, 
  product, 
  total_spend
  FROM top_two
  WHERE r <=2 
  ORDER BY category, r

--baitap 8 
  WITH top_10 AS(
-- lay danh sach top 10 
SELECT a.artist_name,
  DENSE_RANK() OVER(ORDER BY COUNT(b.song_id) DESC) as artist_rank --rank artist co nhieu bai hat 
FROM artists a  
JOIN songs b ON a.artist_id = b.artist_id
JOIN global_song_rank c ON b.song_id = c.song_id
WHERE c.rank <=10
GROUP BY a.artist_name )

SELECT artist_name, artist_rank
FROM top_10
WHERE artist_rank <=5

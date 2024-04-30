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

--baitap 4 

MID-COURSE 

  baitap1: 
  SELECT * 

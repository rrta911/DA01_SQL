--baitap 1 
SELECT b.continent, FLOOR(AVG(a.population))
FROM CITY a
INNER JOIN COUNTRY b ON a.countrycode = b.code 
GROUP BY b.continent

--baitap 2 

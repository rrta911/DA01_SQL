--baitap 1
  SELECT 
  SUM(
    CASE 
    WHEN device_type = 'laptop' THEN 1 
    ELSE 0 END) AS laptop_views,
    SUM(
      CASE 
      WHEN device_type IN ('tablet', 'phone') THEN 1 
      ELSE 0 END) AS mobile_views
FROM viewership;

--baitap 2 
  SELECT *,
    CASE 
        WHEN  x + y > z  AND y + z > x  AND x + z > y THEN 'Yes' 
        ELSE 'No'  
    END AS triangle 
FROM Triangle;

--baitap 3

--baitap 4 
  select name 
  from customer 
  where referee_id != 2 OR referee_id IS NULL;\

--baitap 5 
  select survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
from titanic
GROUP BY survived;

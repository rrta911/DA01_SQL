-- baitap1 
  select name 
  from city 
  where population > 120000 AND countrycode = 'USA'; 

-- baitap2 
  select *
  from city 
  where  countrycode = 'JPN';

-- baitap3 
  select city, state 
  from station;

-- baitap 4 
  select distinct city 
  from station 
  where city LIKE '[a,e,i,o,u]%';
  select distinct city 
  from station 
  where city LIKE 'a%' OR city LIKE 'e%'  OR city LIKE 'i%'  OR  city LIKE 'o%' OR  city LIKE 'u%';

-- baitap 5 
  select distinct city 
  from station 
  where city LIKE '%a' OR city LIKE '%e'  OR city LIKE '%i'  OR  city LIKE '%o' OR  city LIKE '%u';

--baitap 6 
  select distinct city 
  from station 
  where city LIKE '%a' OR city LIKE '%e'  OR city LIKE '%i'  OR  city LIKE '%o' OR  city LIKE '%u';

--bai tap 7
  select name 
  from employee
  order by name ASC;

-- baitap 8 
  select name 
  from employee
  where salary > 2000 and months <10 
  order by employee_id ASC;
-- baitap 9 
  select product_id
  from products 
  where low_fats = 'Y' and recyclable = 'Y';

--baitap 10
  select name 
  from customer 
  where referee_id != 2 OR referee_id IS NULL;

-- baitap 11
  select name, population, area
  from world
  where  population >= 25000000  OR area >= 3000000 ;

--baitap 12
  select distinct author_id as id 
  from views
  where viewer_id = author_id AND viewer_id >= 1 
  order by author_id ASC; 
--baitap 13
  SELECT part, assembly_step FROM parts_assembly
  WHERE finish_date IS NULL;

-- baitap 14 
  select * 
  from lyft_drivers
  WHERE yearly_salary <= 30000 OR yearly_salary >= 70000 ;

-- baitap 15
  select * from uber_advertising 
  where money_spent > 100000 and year = 2019;

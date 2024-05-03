--baitap 1 
  with a AS (
  SELECT company_id, COUNT(company_id) duplicate_companies
  FROM job_listings
  GROUP BY company_id)
  SELECT COUNT(duplicate_companies)
  FROM a  
  WHERE duplicate_companies >1 

 --baitap 2 

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

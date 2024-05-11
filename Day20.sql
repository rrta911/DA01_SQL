
/* Bước 1: Khám phá & Làm sạch dữ liệu
- Chúng ta đang quan tâm đến trường nào?
- Check null
- Chuyển đổi kiểu dữ liệu
- Số tiền và số lượng > 0
- check dup*/
-- có 541909 bản ghi; 135080 bản ghi có customerid null
WITH online_retail_covert as(
select
invoiceno,
stockcode,
description,
CAST(quantity AS int) as quantity,
CAST (invoicedate as timestamp) as invoicedate,
CAST (unitprice as numeric) as unitprice,
customerid, 
country
from online_retail
WHERE customerid <>''
AND CAST(quantity AS int) > 0 and CAST (unitprice as numeric) > 0)

select * from( SELECT*,
ROW_NUMBER() OVER(PARTITION BY invoiceno, stockcode, quantity ORDER BY invoicedate) as stt
FROM online_retail_covert) t
where stt >1

/* Bước 2: 
- Tìm ngày mua hàng đầu tiên của mỗi KH => cohort_date
- Tìm index = tháng (ngày mua hàng - ngày đầu tiên) +1
- count số lượng KH hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng 
- Pivot table*/ 

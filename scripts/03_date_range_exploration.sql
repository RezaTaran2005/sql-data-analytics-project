
-- Determine the first and last order date and the total duration in months
SELECT
MIN(order_date)  "first" ,
MAX(order_date) "last" ,
DATEDIFF (month,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
MIN(birthdate)  youngest ,
MAX(birthdate) oldest ,
GETDATE() "Current_date",
DATEDIFF (year,MAX(birthdate),Getdate()) AS youngest_age,
DATEDIFF (year,min(birthdate),Getdate()) AS oldest_age
from gold.dim_customers;

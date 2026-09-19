-- Create Report: gold.report_customers
CREATE VIEW gold.report_customers AS
-- Base Query: Retrieves core columns from tables
WITH base_query AS (
SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT (c.first_name ,'-',c.last_name) customer_name,
DATEDIFF (YEAR,c.birthdate,GETDATE()) age
FROM gold.fact_sales f
LEFT JOIN  gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
)

-- Customer Aggregations: Summarizes key metrics at the customer level
,customer_aggregation AS (
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM (quantity) AS total_quantity,
COUNT (DISTINCT product_key) AS total_products,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name,
age
)


SELECT
customer_key,
customer_number,
customer_name,
age,

CASE
WHEN age < 20 THEN '- 20'
WHEN age between 20 and 29 THEN '20-29'
WHEN age between 30 and 39 THEN '30-39'
WHEN age between 40 and 49 THEN '40-49'
ELSE '+ 50'
END AS age_group,

CASE 
WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
ELSE 'NEW'
END AS customer_segment,

last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products
lifespan,

-- average order value
CASE 
WHEN total_sales = 0 THEN 0
ELSE total_sales / total_orders
END AS avg_order_value,

-- average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
ELSE total_sales / lifespan
END AS avg_monthly_spend

FROM customer_aggregation



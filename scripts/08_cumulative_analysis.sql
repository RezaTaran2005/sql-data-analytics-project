--total sales per month & running total of sales over time 

SELECT
t.order_date,
t.total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG (avg_price) OVER (ORDER BY order_date) as moving_average_price
FROM 
(
SELECT
DATETRUNC(month,order_date) AS order_date,
SUM(sales_amount)AS total_sales,
AVG (price) AS avg_price
FROM gold.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)

) t

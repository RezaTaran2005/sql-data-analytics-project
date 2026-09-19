-- Categories with the largest share of sales
WITH category_sales AS(
SELECT
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.category
)
SELECT 
total_sales,
category,
SUM (total_sales) OVER () AS overall_sales,
ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;



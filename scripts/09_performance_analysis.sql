
WITH yearly_products_sales AS (
SELECT 
YEAR(f.order_date) order_year,
p.product_name,
SUM(f.sales_amount) current_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key 
WHERE f.order_date IS NOT NULL
GROUP BY 
YEAR(f.order_date) , p.product_name
) 
SELECT 
order_year,
product_name,
current_sales,
AVG (current_sales) OVER (PARTITION BY product_name) avg_sales,
current_sales - AVG (current_sales) OVER (PARTITION BY product_name) diff_avg,

CASE 
WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) < 0 THEN 'BELOW AVG'
WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) > 0 THEN 'ABOVE AVG'
ELSE 'AVG'
END avg_change,

LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) diff_py,

CASE 
WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'DECRASE'
WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'INCREASE'
ELSE 'NO CHANGE'
END py_change

FROM yearly_products_sales
ORDER BY product_name,order_year,diff_py;




WITH monthly_products_sales AS (
SELECT 
YEAR(f.order_date) order_year,
MONTH(f.order_date) order_month,
p.product_name,
SUM(f.sales_amount) current_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key 
WHERE f.order_date IS NOT NULL
GROUP BY 
YEAR(f.order_date),
MONTH(f.order_date),
p.product_name
) 
SELECT 
order_year,
order_month,
product_name,
current_sales,
AVG (current_sales) OVER (PARTITION BY product_name) avg_sales,
current_sales - AVG (current_sales) OVER (PARTITION BY product_name) diff_avg,

CASE 
WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) < 0 THEN 'BELOW AVG'
WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) > 0 THEN 'ABOVE AVG'
ELSE 'AVG'
END avg_change,

LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) pm_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) diff_pm,

CASE 
WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) < 0 THEN 'DECRASE'
WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year, order_month) > 0 THEN 'INCREASE'
ELSE 'NO CHANGE'
END pm_change

FROM monthly_products_sales
ORDER BY product_name, order_year, order_month, diff_pm;
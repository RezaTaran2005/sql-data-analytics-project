SELECT 
DISTINCT
country 
FROM gold.dim_customers
ORDER BY country;

SELECT 
DISTINCT 
category, 
subcategory, 
product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

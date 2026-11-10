/*
======================================================================================
Product Report
======================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range and Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- Recency (Months since last sale)
		- Average order Revenue (AOR)
		- Average monthly Revenue

To use:
	SELECT * FROM gold.report_products
======================================================================================
*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
/*
----------------------------------------------------------------------------
1) Base query: Retrieves core columns from the table
----------------------------------------------------------------------------
*/

SELECT 
	s.order_number,
	s.order_date,
	s.customer_key,
	s.sales,
	s.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL   -- Only consuder vlaid dates
),

product_aggregations AS (
/*
----------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at product level
----------------------------------------------------------------------------
*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales AS FLOAT)/NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

/*
----------------------------------------------------------------------------
1) Final query: Combines all product outputs into one output
----------------------------------------------------------------------------
*/

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >=10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
	
	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales/lifespan
	END AS avg_monthly_revenue
FROM product_aggregations

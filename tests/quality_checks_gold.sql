/*
=============================================================================
Quality Chceks
=============================================================================
Script Purpose:
  This script performs quality checks to validate the integrity, consistency,
  and accuracy of the Gold layer. These checks ensure:
  - Uniqueness of Surrogate keys in dimenstion tables.
  - Referential integrity between fact and dimension tables.
  - Validity of relationships in the data model for analytical purpose.

Usage Notes:
  - Run these checks after data loading in Silver layer.
  - Investigate and resolve any discrepancies found during the checks.
=============================================================================

*/

-- =============================================================================
-- checking 'gold.dim_customers'
-- =============================================================================
-- Check for uniqueness of Customer Key in gold.dim_customers
--Expectation: No results
SELECT 
  customer_key,
  COUNT(*) AS duplicate_count
FROM gold.dim_products  
GROUP BY customer_key
HAVING COUNT(*) > 1;
  
-- =============================================================================
-- checking 'gold.product_key'
-- =============================================================================
-- Check for uniqueness of Prodduct Key in gold.dim_products
--Expectation: No results
SELECT 
  product_key,
  COUNT(*) AS duplicate_count
FROM gold.dim_products  
GROUP BY product_key
HAVING COUNT(*) > 1;
  
-- =============================================================================
-- checking 'gold.fact_sales'
-- =============================================================================
-- Check the data model connectivity between fact and dimenstions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL

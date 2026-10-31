/*
=============================================================================================
Quality Checks
=============================================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy
  and standardization across the 'silver' schemas. it includes checks for:
  - Null or Duplicate Primary Key.
  - Unwanted spaces in string fields.
  - Data standardication and Consistency.
  - Invalid date changes and orders.
  - Data consistency between related fields.

Usage notes:
  - Run these checks after loading data to Silver Layer
  - Investigate and resolve a ny discrepancies found during the checks.
=============================================================================================
*/


--Check for Duplicate PRIMARY KEY
----------------------------------
SELECT 
cid, count(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1 or cid IS NULL



-- Check for unwanted spaces
-- Expecation: No results
----------------------------------
SELECT cat,subcat FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat) OR cat != TRIM(cat) or maintainence != TRIM(maintainence)

SELECT *
from silver.crm_prd_info


-- Check for NULLS or Negative numbers
----------------------------------
SELECT prd_cost
from silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Data Standardization & Consistency
----------------------------------
SELECT 
	DISTINCT maintainence
from bronze.erp_px_cat_g1v2

WHERE sls_price != sls_quantity * sls_sales
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0


-- Check for invalid date orders
----------------------------------
SELECT *
from silver.erp_cust_az12
WHERE bdate >= GETDATE()


SELECT * from silver.erp_loc_a101

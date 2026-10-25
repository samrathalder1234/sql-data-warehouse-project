/*
=============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================

Script Purpose: 
  This stored procedure loads data into the 'Bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the Bronze tables before loading date.
  - Uses the 'BULK INSERT' command to load data from CSV files to Bronze tables.

Parameters:
    None.
  This stored procedure does not accept any parameters or retuen any values.

Usage Example:
  EXEC bronze.load_bronze;
==============================================================

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @total_load_start_time DATETIME, @total_load_end_time DATETIME;
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '==========================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==========================================';

		PRINT '------------------------------------------';
		PRINT 'Loading CRM tables';
		PRINT '------------------------------------------';

		SET @total_load_start_time = GETDATE();

		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT'>> Inserting data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------'


		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT'>> Inserting data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------'


		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT'>> Inserting data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------'


	
		PRINT '------------------------------------------';
		PRINT 'Loading ERP tables';
		PRINT '------------------------------------------';
		

		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT'>> Inserting data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------'


		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT'>> Inserting data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------'


		SET @start_time  = GETDATE();
		PRINT'>> Truncating table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT'>> Inserting data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\v-sahalder\OneDrive - Microsoft\Desktop\Courses\Data warehousing - Udemy\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time  = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------';

		SET @total_load_end_time = GETDATE();
		PRINT '---Loading Bronze layer completed---'; 
		PRINT '========================================';
		PRINT '>> Total Bronze Load duration: ' + CAST(DATEDIFF(second, @total_load_start_time, @total_load_end_time) AS NVARCHAR) + ' seconds';
		PRINT '========================================';

	END TRY
	BEGIN CATCH
		PRINT '==========================================';
		PRINT 'ERROR OCCURED WHILE LOADING BRONZE LAYER';
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';
	END CATCH
END

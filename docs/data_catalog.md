# Data Dictionary for Gold Layer

## Overview


The Gold Layer is business-level data representation, structured to support analytical and reporting use cases. It consists of **dimenstion tables** and **fact tables** for specific business metrics.
---
### 1. gold.dim_customers
  - **Purpose**: Stores customer details enriched with demographic and geographic data.
  - **Columns**:
| Column Name | Data Type | Description |
| customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table.|
| customer_id | INT | Unique numerical identifier|
| customer_number | NVARCHAR(50) | 
| first_name | NVARCHAR(50) |
| last_name | NVARCHAR(50) |
| country | NVARCHAR(50) |
| marital_status | NVARCHAR(50) |
| gender | NVARCHAR(50) |
| birthdate | DATE | 
| create_date| DATE | 

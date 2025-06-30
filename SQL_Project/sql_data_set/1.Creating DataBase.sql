/*

Create Database and Schemas
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics'
     Additionally, this script creates a schema called gold
*/

use master;
go
-- Create the 'DataWarehouseAnalytics' database
create database DataWarehouseAnalytics2;
go
use DataWarehouseAnalytics2;
go
-- Create Schemas

create schema gold;
go
create table gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
go
create table gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
go
create table gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
go

truncate table gold.dim_customers;
go

bulk insert gold.dim_customers
from 'path of file to be imported'
with (
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
go

truncate table gold.dim_products;
go

bulk insert gold.dim_products
from 'path of file to be imported'
with (
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
go

truncate table gold.fact_sales;
go

bulk insert gold.fact_sales
from 'path of file to be imported'
with (
	firstrow = 2,
	fieldterminator = ',',
	tablock
);
go

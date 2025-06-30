/*
Customer Report
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
*/

-- Create Report: gold.report_customers
create view report_customers as
      
with base_query as(
select
      f.order_number,
      f.product_key,
      f.order_date,
      f.sales_amount,
      f.quantity,
      c.customer_key,
      c.customer_number,
concat(c.first_name,' ',c.last_name) as customer_name,
datediff(year,c.birthdate ,GETDATE()) as age
from [gold.fact_sales] f
left join [gold.dim_customers] c
on f.customer_key=c.customer_key
where order_date is not null
)

,customer_aggregation as(
select 
      customer_key,
      customer_number,
      customer_name,
      age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key ) as total_products,
max(order_date) as last_order_date,
datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by  customer_key,
          customer_number,
          customer_name,
          age
)
select 
      customer_key,
      customer_number,
      customer_name,
      age,
case when age<20 then 'Under 20'
     when age between 20 and 29 then '20-29'
     when age between 30 and 39 then '30-39'
     when age between 40 and 49 then '30-39'
     else 'Above 50'
end as age_group,
case when lifespan>=12 and total_sales >5000 then 'VIP'
     when lifespan>=12 and total_sales<=5000 then 'Regular'
     else 'newbie'
end as customer_segment,
      last_order_date,
      datediff(month,last_order_date,getdate()) as recency,
      total_sales,
      total_quantity,
      total_products,
      lifespan,
-- Compute average order value (Av0)
case when total_orders = 0 then 0
     else total_sales/total_orders  
end  avg_order_value,

-- compute average monthly spend
case when lifespan=0 then total_sales
     else total_sales/lifespan 
end avg_monthly_spends
from customer_aggregation;

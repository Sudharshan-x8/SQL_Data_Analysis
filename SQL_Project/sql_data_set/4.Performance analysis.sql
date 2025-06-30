/*
Performance Analysis (Year-over-Year, Month-over-Month)
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
*/

with yearly_product_sales as(
     select
           year(f.order_date) as order_year,
           p.product_name,
           sum(f.sales_amount) as total_sales
     from [gold.fact_sales] f
     left join [gold.dim_products] p
     on f.product_key=p.product_key
     where order_date is not null
     group by year(f.order_date),p.product_name
)
select 
      order_year,
      product_name,
      total_sales,
      avg(total_sales) over (partition by product_name) as avg_sales,
      total_sales-avg(total_sales) over (partition by product_name) as diff_sales,
      case when  total_sales-avg(total_sales) over (partition by product_name)>0 then 'Above avg'
           when  total_sales-avg(total_sales) over (partition by product_name)<0 then 'Below avg'
           else 'Avg'
      end as avg_change,
       -- Year-over-Year Analysis
      lag(total_sales) over (partition by product_name order by order_year) as Prev_year,
      total_sales -lag(total_sales) over (partition by product_name order by order_year) as prev_curr_diif,
      case when  total_sales -lag(total_sales) over (partition by product_name order by order_year)>0 then 'Increasing'
           when  total_sales -lag(total_sales) over (partition by product_name order by order_year)<0 then 'Decreasing'
           else 'No change'
      end as sales_change
from yearly_product_sales
order by product_name,order_year;
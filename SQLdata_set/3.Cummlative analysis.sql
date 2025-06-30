/*
Cumulative Analysis
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
*/

select 
      date_of,
      total_sales,
      sum(total_sales) over( order by date_of) as running_total,
      avg(avg_price) over(order by date_of) as moving_avg
from
(
  select 
        datetrunc(month,order_date) as date_of,
        sum(sales_amount) as total_sales,
        avg(sales_amount) as avg_price
  from [gold.fact_sales]
  where order_date is not null
  group by datetrunc(month,order_date)
) t
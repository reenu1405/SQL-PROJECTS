use selfschema;
select * from cvs_health1;


'''
-- Definition:

cogs stands for Cost of Goods Sold which is the direct cost associated with producing the drug.
Total Profit = Total Sales - Cost of Goods Sold
pharmacy_sales Table:
Column Name	Type
product_id	integer
units_sold	integer
total_sales	decimal
cogs	decimal
manufacturer	varchar
drug	varchar
'''
CREATE TABLE `cvs_health1` (
  `product_id` int DEFAULT NULL,
  `units_sold` int DEFAULT NULL,
  `total_sales` double DEFAULT NULL,
  `cogs` double DEFAULT NULL,
  `manufacturer` text,
  `drug` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. Each drug can only be produced by one manufacturer.
select * from cvs_health1;
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits. Display the result from the highest to the lowest total profit.
SELECT drug,total_sales-cogs as total_profit
  FROM pharmacy_sales
    ORDER BY total_profit desc
      limit 3;

-- Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health and calculate the total amount of losses incurred.

select manufacturer,count(drug),
abs(sum(total_profit))as total_loss
from (SELECT manufacturer,drug,total_sales-cogs as total_profit
  FROM pharmacy_sales
    ORDER BY total_profit asc)a
where total_profit<0
GROUP BY manufacturer
    ORDER BY total_loss desc;

select * from cvs_health1;
-- Write a query to find the total drug sales for each manufacturer. Round your answer to the closest million, and report your results in descending order of total sales.
WITH cte as (SELECT manufacturer,(sum(total_sales)/1000000) as sale
  FROM pharmacy_sales
  GROUP BY manufacturer
  ORDER BY sale DESC
    )
    SELECT manufacturer,concat('$',round(sale),' million') as sales_mil
       from cte;


select * from cvs_health1;
-- Write a query to find the top 2 drugs sold, in terms of units sold, for each manufacturer. List your results in alphabetical order by manufacturer.
with sorted_sales as (SELECT manufacturer,drug,units_sold,
row_number()OVER(PARTITION BY manufacturer ORDER BY units_sold desc) as rn
from pharmacy_sales )

SELECT manufacturer,drug
from sorted_sales
where rn <3;

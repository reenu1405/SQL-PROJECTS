/* project
Credit Card Transactions:
** About the dataset **:
This dataset contains insights into a collection of credit card transactions made in India, 
offering a comprehensive look at the spending habits of Indians across the nation. 
From the Gender and Card type used to carry out each transaction, to which city saw the highest amount of spending 
and even what kind of expenses were made, this dataset paints an overall picture about how money is being spent in India today. 
With its variety in variables, researchers have an opportunity to uncover deeper trends in customer spending 
as well as interesting correlations between data points that can serve as invaluable business intelligence.
Whether you're interested in learning more about customer preferences or simply exploring unbiased data analysis techniques,
this data is sure to provide insight beyond what one could anticipate

** Skills used **: Joins, CTE's, sub queries, Windows Functions, Aggregate Functions,Aggregate with  Windows Functions, Creating Views,
Date Functions
*/
use selfdb;
select * from credit_card_transaction;

/*
-- 1- write a query to print top 5 cities with highest spends and their percentage 
-- contribution of total credit card spends */

select * from credit_card_transaction;
	
select *,
(select sum(amount) 
from credit_card_transaction)as total_spend
from credit_card_transaction;

 with cte1 as (
select city,sum(amount) as total_spend
from credit_card_transaction
group by city)
,total_spent as (select sum(CAST(CONV(amount,10,10) AS UNSIGNED INTEGER)) as total_amount from credit_card_transaction)
select  cte1.*, round(total_spend*1.0/total_amount * 100,2) as percentage_contribution from 
cte1 inner join total_spent on 1=1
order by total_spend desc
limit 5;
-- ------------------------------------------------------------
select * from credit_card_transaction;

 -- 2- write a query to print highest spend month and amount spent in that month for each card type 
 
with cte as (select card_type,extract(year from datess) as years,
extract(month from datess) as months,
sum(amount) as total from credit_card_transaction
group by card_type,extract(year from datess) ,extract(month from datess) )
select * from(select * ,
rank()over(partition by card_type order by total desc) as rn
from cte)a where rn=1;
-- ------------------------------------------------------------
select * from credit_card_transaction;
/*
 3- write a query to print the transaction details(all columns from the table) for each card type when
 it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
*/

with cte as (
select *,sum(amount) over(partition by card_type order by datess,indexss) as total_spend
from credit_card_transaction
-- order by card_type,total_spend desc
)
select * from (select *, rank() over(partition by card_type order by total_spend) as rn  
from cte where total_spend >= 1000000) a where rn=1

-- ------------------------------------------------------------
-- 4- write a query to find city which had lowest percentage spend for gold card type

with cte as(select city,sum(amount) as total,
sum(case when card_type= 'Gold' then amount end) as gold_total
from credit_card_transaction
group by  city
having gold_total>0
order by gold_total)
select city,gold_total*1.0/total as percent
from cte
order by percent
limit 1;
-- ------------------------------------------------------------
select * from credit_card_transaction;

-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
-- and also Create View to store data for later visualizations

with cte as(select city, exp_type,sum(amount) as total
from credit_card_transaction
group by city, exp_type)
select city,
min(case when arn=1 then exp_type end) as lowest_expense_type,
max(case when drn=1 then exp_type end) as highest_expense_type
from
(select *,
rank()over(partition by city order by total) as arn,
rank()over(partition by city order by total desc) as drn
from cte)a group by city;
-- ---------------------
Create View expenses_of_cities as
with cte as(select city, exp_type,sum(amount) as total
from credit_card_transaction
group by city, exp_type)
select city,
min(case when arn=1 then exp_type end) as lowest_expense_type,
max(case when drn=1 then exp_type end) as highest_expense_type
from
(select *,
rank()over(partition by city order by total) as arn,
rank()over(partition by city order by total desc) as drn
from cte)a group by city;

-- ---------------------------------------------------------------------------
select * from credit_card_transaction;
-- 6- write a query to find percentage contribution of spends by females for each expense type

select exp_type,percentage_female_contribution*100.0/total as percent
from
(select exp_type,sum(amount) as total
,sum(case when gender='f' then amount end) as percentage_female_contribution
from credit_card_transaction
group by exp_type)a;
-- ------
select exp_type,
sum(case when gender='F' then amount else 0 end)*1.0/sum(amount) as percentage_female_contribution
from credit_card_transaction
group by exp_type
order by percentage_female_contribution desc;
-- ------------------------------------------------------------
select * from credit_card_transaction;

-- 7- which card and expense type combination saw highest month over month growth in Jan-2014

with cte as(select card_type,exp_type ,extract(year_month from datess) as yearmonth
,sum(amount) as spend
from credit_card_transaction
group by card_type,exp_type ,extract(year_month from datess))
select * , year1401-year1312 as mon_growth
from (select card_type,exp_type,
max(case when yearmonth ='201312' then spend end )as year1312
,max(case when yearmonth ='201401' then spend end) as year1401
from cte
group by card_type,exp_type
order by card_type)b
order by mon_growth desc
limit 1;

-- ------------------------------------------------------------
-- 8- during weekends which city has highest total spend to total no of transcations ratio 

with cte as (select city ,sum(amount) as total,
sum(case when dayname in ('Saturday' ,'Sunday') then amount end) weekendsale
from (select *, dayname(datess) as dayname
from credit_card_transaction)a
group by city
order by weekendsale desc)
select city ,weekendsale*100.0/total as totalspend
from cte
limit 1;
-- ------------------------------------------------------------

-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city

with cte as (
select *
,row_number() over(partition by city order by datess,indexss) as rn
from credit_card_transaction)
select  city,datediff(max(datess),min(datess)) as datediff1
from cte
where rn=1 or rn=500
group by city
having count(1)=2
order by datediff1 
limit 1;

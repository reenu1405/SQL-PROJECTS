/*
Dataset Superstore orders :
** About Dataset** :
Context:With growing demands and cut-throat competitions in the market,
a Superstore Giant is seeking your knowledge in understanding what works best for them. 
They would like to understand which products, regions, categories and customer segments they should target or avoid.
** Metadata **
Row ID => Unique ID for each row.
Order ID => Unique Order ID for each Customer.
Order Date => Order Date of the product.
Ship Date => Shipping Date of the Product.
Ship Mode=> Shipping Mode specified by the Customer.
Customer ID => Unique ID to identify each Customer.
Customer Name => Name of the Customer.
Segment => The segment where the Customer belongs.
Country => Country of residence of the Customer.
City => City of residence of of the Customer.
State => State of residence of the Customer.
Postal Code => Postal Code of every Customer.
Region => Region where the Customer belong.
Product ID => Unique ID of the Product.
Category => Category of the product ordered.
Sub-Category => Sub-Category of the product ordered.
Product Name => Name of the Product
Sales => Sales of the Product.
Quantity => Quantity of the Product.
Discount => Discount provided.
Profit => Profit/Loss incurred.

*/

-- 1- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character
select * from orders where customer_name like '_a_d%';

-- 2- write a sql to get all the orders placed in the month of dec 2020 
select * from orders 
where  order_date between '2020-12-01' and '2020-12-31';
-- or 
select * from orders 
where  order_date like '2020-11-__';

-- 3- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020
select * from orders
where  ship_mode not in ('Standard Class','First Class')
and ship_date > '2020-11-30';

-- 4- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" 
select * from orders where customer_name not like 'A%n';

-- 5- write a query to get all the orders where profit is negative 
select * from orders where profit<0
;
-- 6- write a query to get all the orders where either quantity is less than 3 or profit is 0 
select * from orders where profit=0 or quantity<3;

-- 7- your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers
select * from orders where region='South' and discount>0;

-- 8- write a query to find top 5 orders with highest sales in furniture category 
select top 5 * from orders
where category='Furniture' order by sales desc 
-- in mysql
select * from orders
where category='Furniture' order by sales desc 
limit 5;

-- 9- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only
select   * from orders where category in ('Furniture','Technology') 
and order_date between '2020-01-01' and '2020-12-31';


-- 10-write a query to find all the orders where order date is in year 2020 but ship date is in 2021 
select   * from orders where 
order_date between '2020-01-01' and '2020-12-31' 
and ship_date between '2021-01-01' and '2021-12-31'

-- 11- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

update orders set city=null
where order_id in ('CA-2020-161389','US-2021-156909');

-- 12- write a query to find orders where city is null (2 rows)
select * from orders where city is null;


-- 13- write a query to get total profit, first order date and latest order date for each category
select category , sum(profit) as total_profit,
min(order_date) as first_order_date,max(order_date) as latest_order_date
from orders
group by category ;


-- 14- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category
select sub_category
from orders
group by sub_category
having avg(profit) > max(profit)/2;


-- 15- create the exams table with below script;
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

write a query to find students who have got same marks in Physics and Chemistry.

select student_id , marks
from exams
where subject in ('Physics','Chemistry')
group by student_id , marks
having count(marks)=2;


-- 16- write a query to find total number of products in each category.
select category,count(distinct product_id) as no_of_products
from orders
group by category;


-- 17- write a query to find top 5 sub categories in west region by total quantity sold
select top 5  sub_category, sum(quantity) as total_quantity
from orders
where region='West'
group by sub_category
order by total_quantity desc;
-- in mysql
select sub_category, sum(quantity) as total_quantity
from orders
where region='West'
group by sub_category
order by total_quantity desc
limit 5;

-- 18- write a query to find total sales for each region and ship mode combination for orders in year 2020
select region,ship_mode ,sum(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region,ship_mode;

-- 19- write a query to get region wise count of return orders
select o.region,count(distinct o.order_id) as no_of_return_orders
from orders o
inner join returns r on o.order_id=r.order_id
group by o.region;

-- 20- write a query to get category wise sales of orders that were not returned
select o.category,sum(o.sales) as total_sales
from orders o
left join returns r on o.order_id=r.order_id
where r.order_id is null
group by o.category;


-- 21- write a query to print dep name and average salary of employees in that dep .
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name;

-- 22- write a query to print dep names where none of the emplyees have same salary.
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(distinct e.salary)=1;

-- 23- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3;

-- 24- write a query to find cities where not even a single order was returned.
select o.city
from orders o
left join returns r on o.order_id=r.order_id
group by o.city
having count(r.order_id)=0;

-- 25- write a query to find top 3 subcategories by sales of returned orders in east region
select top 3 o.sub_category,sum(o.sales) as return_sales
from orders o
inner join returns r on o.order_id=r.order_id
where o.region='East'
group by o.sub_category
order by return_sales  desc;

-- 26- write a query to print dep name for which there is no employee
select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;

-- 27- write a query to print employees name for which dep id is not avaiable in dept table
select e.*
from employee e 
left join dept d  on e.dept_id=d.dep_id
where d.dep_id is null;







-- Customer Churn Analysis Project
create database bank_churn;
use bank_churn;
select* from bank_churn;
-- Create customers table
CREATE TABLE customers AS
SELECT 
    customer_id,
    credit_score,
    geography,
    gender,
    age,
    tenure
FROM bank_churn;
select * from customers;
-- Create accounts table
create table accounts as
select
customer_id,
balance,
num_of_products,
has_credit_card,
is_active_member,
estimated_salary,
exited
FROM bank_churn;
select * from accounts;
-- Verify JOIN is working
select *               
from customers c
join accounts a
on c.customer_id = a.customer_id;
-- Total customers
select count(distinct c.customer_id) as total_customers # Total customers
from customers c
join accounts a
on c.customer_id = a.customer_id;
-- Churn rate
select round(avg(exited)*100,2) as churn_rate_percentage		
from accounts;
-- Churn by gender
select gender,sum(exited)                              
from customers
join accounts
on customers.customer_id = accounts.customer_id
group by gender;
-- Churn by geography												
select geography,sum(exited) as churned           
from customers
join accounts
on customers.customer_id = accounts.customer_id
group by geography
order by churned desc;
-- High Balance Customers Who Churned
select customers.customer_id,balance,exited         
from customers
join accounts
on customers.customer_id = accounts.customer_id      
where exited = 1
order by balance desc
limit 5;     
 -- Active vs Inactive Customers 
select is_active_member,count(*) as total_customers,            
sum(exited)as churned       
from accounts
group by is_active_member; 
-- Customers with more than 2 products
select customer_id,num_of_products from accounts               
where num_of_products > 2;
-- Customers older than average age
select * from  customers                                       
where age > (
select avg(age) from customers);
-- High risk customers
SELECT customer_id,balance,is_active_member,estimated_salary                   
FROM accounts
WHERE balance > 100000 AND is_active_member = 0;
-- Customers age > 30 and inactive/no credit card
select * from customers                                  
join accounts
on customers.customer_id = accounts.customer_id
where age>30
and (has_credit_card = 0 or is_active_member = 0);
-- Customers above 55 with no account
select customers.customer_id,customers.age,accounts.balance		
from customers
left join accounts
on customers.customer_id = accounts.customer_id
WHERE customers.age > 55
AND accounts.customer_id IS NULL;
-- Customers with below average balance
select customers.customer_id,accounts.balance  
from customers
inner join accounts
on customers.customer_id = accounts.customer_id
where accounts.balance <
(select avg(balance)from accounts);
-- Geography contains 'a'
select customer_id,geography from customers          
where geography like '%a%';
-- Tenure groups with more than 100 customers
select tenure, COUNT(*) AS total_customers     
from customers
group by tenure
having total_customers > 100;
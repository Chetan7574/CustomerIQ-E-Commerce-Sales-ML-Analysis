use ECommerceAnalytics
select * from Customerrss
select * from Orderrss

---1) Total numbers of Customers
---Why= To get overall size of Data 
select count(*) as total_customers from Customerrss
select count(*) as total_orders from Orderrss

---2) Total Revenue Generated from Orders 
---Why= To get Total income from orders 
select round(sum(TotalAmount),0) as total_income from Orderrss

---3) Average Order Value (AOV)
---Why= Shows revenue efficiency per transaction — a core KPI.
select AVG(TotalAmount) as avg_amount from Orderrss

---4) Most Popular Product Category
---Why= Identifies customer preferences and helps in marketing focus.
select top 1 ProductCategory,count(*) as Total_orders from Orderrss
group by ProductCategory
order by Total_orders desc 

---5) Highest Spending Top 5 Customers
---Why= Combines data from both tables to find valuable customers.
select top 5  c.FirstName,c.LastName,round(sum(o.TotalAmount),0) as Total_spent 
from Customerrss c 
join Orderrss o on c.CustomerID=o.CustomerID 
group by c.FirstName,c.LastName
order by Total_spent Desc 

---6) Orders by Payment Mode
---Why= Helps understand customer payment preferences.
select PaymentMethod,count(*) as total_orders
from Orderrss
group by PaymentMethod
order by total_orders desc 

---7) Gender-based Orders 
---Why= To see if spending patterns differ by gender
select c.Gender,count(o.OrderID) as total_orders  
from Customerrss c
join Orderrss o on c.CustomerID=o.CustomerID
group by c.Gender
order by total_orders desc

---8) Revenue by City (Top 5 Cities)
---Why= Helps focus marketing efforts on high-performing regions.
select top 5 c.City,round(sum(o.TotalAmount),0) as total_Revenue
from Customerrss c 
join Orderrss o on c.CustomerID=o.CustomerID 
group by c.City 
order by total_Revenue Desc

---9) Orders Placed in Each Month
---Why= Seasonal trend analysis.
select MONTH(Orderdate) as Month ,count(*) as total_orders
from Orderrss
group by month(OrderDate)
order by month(OrderDate) asc 

---10) Using Subquery — Above Average Spenders
---Why= Identifies high-value customers using nested logic.
select top 10 c.FirstName,sum(o.TotalAmount) AS Total_amount  
from Customerrss c
join Orderrss o on c.CustomerID=o.CustomerID
group by c.FirstName
having sum(o.TotalAmount) > (Select avg(TotalAmount) from Orderrss) 

---11) Rank Customers by Spending Amount 
---Why= Cleanly organizes complex ranking logic
select c.firstname,c.lastname,round(sum(o.totalAmount),0) as total_spend,
RANK() over (order by round(sum(o.totalAmount),0) desc ) as Customer_ranking 
from Customerrss c 
join Orderrss o on c.CustomerID=o.CustomerID
group by c.firstname,c.lastname
order by Customer_ranking  

---12) Customer Order Frequency Classification
---Why= Demonstrates SQL conditional logic and customer segmentation — a key business use case.
select c.FirstName,c.LastName,count(o.orderID) as total_orders,
case
when count(o.orderID) >= 10 then 'Frequent'
when count(o.orderID) between 4 and 9 then 'Regular'
else 'Occasional'
end as Customer_type
from Customerrss c
inner join Orderrss o on c.CustomerID=o.CustomerID
group by c.FirstName,c.LastName 
order by total_orders desc
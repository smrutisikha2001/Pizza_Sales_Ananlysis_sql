# Pizza_Sales_Ananlysis_sql

PROJECT OVERVIEW

Project Title: Pizza Sales Analysis
Database: pizzahut

OBJECTIVE: 
This project utilizes SQL to conduct a comprehensive analysis of a pizza sales dataset, aiming to extract actionable insights for business improvement. The primary objectives include identifying key sales trends, understanding customer purchasing patterns, and optimizing operational efficiency. By analyzing best-selling products, revenue growth, and customer behavior, this project seeks to provide data-driven recommendations that can enhance marketing strategies, resource allocation, and overall business performance within the pizza sales domain.


DATA ANALYSIS AND FINDINGS:

1. Retrieve the total number of orders placed.
```sql
SELECT 
    COUNT(order_id) AS TotalOrders
FROM
    orders;
```

2. Calculate the total revenue generated from pizza sales.
```sql
SELECT 
    ROUND(SUM((o.quantity * p.price)), 2) AS Total_Revenue
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id;
```

3. Identify the highest-priced pizza.
```sql
SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;
```

4. Identify the most common pizza size ordered.
```sql
SELECT 
    p.size, COUNT(od.order_id) AS OrderCount
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY COUNT(od.order_id) DESC
LIMIT 1;
```

5. List the top 5 most ordered pizza types along with their quantities.
```sql
SELECT 
    pt.name, SUM(od.quantity) Quantity_ordered
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Quantity_ordered DESC
LIMIT 5;
```

6. Join the necessary tables to find the total quantity of each pizza category ordered.
```sql
SELECT 
    pt.category, SUM(od.quantity) Quantity_ordered
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
order by Quantity_ordered;
```

7. Determine the distribution of orders by hour of the day.
```sql
SELECT 
    HOUR(order_time) AS Hours,
    COUNT(order_id) Order_Count
FROM
    orders
GROUP BY Hours
order by Order_Count desc;
```

8. Find the category-wise distribution of pizzas.
```sql
SELECT 
    category, COUNT(pizza_type_id) CountofPizzaType
FROM
    pizza_types
GROUP BY category;
```

9. Group the orders by date and calculate the average number of pizzas ordered per day.
```sql
SELECT 
    ROUND(AVG(NumberOfPizzasOrderes), 0) AS AvergaeOrdersPerDay
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS NumberOfPizzasOrderes
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS Totalorders;
```

10. Determine the top 3 most ordered pizza types based on revenue.
```sql
SELECT 
    pt.name, ROUND(SUM(od.quantity * p.price), 2) AS Revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;
```

11. Calculate the percentage contribution of each pizza type to total revenue.
```sql
SELECT 
    pt.category,
    ROUND((SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM((o.quantity * p.price)), 2)
                FROM
                    pizzas AS p
                        JOIN
                    order_details AS o ON p.pizza_id = o.pizza_id)) * 100,
            2) AS PercentOfRevenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;
```

12. Analyze the cumulative revenue generated over time.
```sql
select order_date,
sum(Revenue) over(order by order_date) as cumulative_revenue
from(
select o.order_date,
sum(od.quantity * p.price) as revenue
from orders as o
join
order_details as od 
on o.order_id = od.order_id
join pizzas as p
on p.pizza_id = od.pizza_id
group by o.order_date) as t;
```

13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```sql
select category, name,revenue,rankoforders
from(
select category,name,revenue,
rank() over(partition by category order by revenue desc) as rankOfOrders
from (
SELECT 
    pt.category, pt.name,
    ROUND(SUM(od.quantity * p.price), 2) AS Revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category,pt.name) t) as b
where rankoforders <=3;
```


KEY FINDINGS:

1. Sales Performance:
Total orders and revenue provide a baseline for business volume.
Identified top-selling and most profitable pizza types and categories.   
Analyzed average daily orders and cumulative revenue growth.

2. Customer Preferences:
Determined the most popular pizza size.
Showed the distribution of orders by time of day (peak hours).   
Revealed category-wise pizza preferences.   

3. Operational Insights:
Highlighted the highest-priced pizza and average price points.   
Provided data for inventory management and staffing optimization.   
Showed the percentage contribution of each pizza category to total revenue.

4. Menu Optimization:
Identified top performers within each pizza category based on revenue.
Data can be used to refine menu offerings and promotions

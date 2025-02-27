-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS TotalOrders
FROM
    orders;
    
    
-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM((o.quantity * p.price)), 2) AS Total_Revenue
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id;
    
    
-- Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_id) AS OrderCount
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY COUNT(od.order_id) DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.

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


-- Join the necessary tables to find the total quantity of each pizza category ordered.

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


-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hours,
    COUNT(order_id) Order_Count
FROM
    orders
GROUP BY Hours
order by Order_Count desc;


-- Find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(pizza_type_id) CountofPizzaType
FROM
    pizza_types
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(NumberOfPizzasOrderes), 0) AS AvergaeOrdersPerDay
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS NumberOfPizzasOrderes
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS Totalorders;  
    
    
-- Determine the top 3 most ordered pizza types based on revenue.

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


-- Calculate the percentage contribution of each pizza type to total revenue.

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


-- Analyze the cumulative revenue generated over time.

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


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

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
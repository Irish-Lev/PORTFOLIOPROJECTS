--KPI´S

SELECT CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Rev 
FROM pizza_sales1

SELECT CAST(SUM(total_price)/COUNT(DISTINCT order_id) AS DECIMAL (10,2)) AS Avg_order_Value 
FROM pizza_sales1

SELECT SUM(quantity) AS Tot_pizza_sold 
FROM pizza_sales1

SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales1

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
            CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
            AS Avg_Pizzas_per_order
FROM pizza_sales1

--HOURLY TREND

SELECT DATEPART(HOUR, order_time) as order_hours, SUM(quantity) as total_pizzas_sold
FROM pizza_sales1
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time)

--WEEKLY TREND

SELECT DATEPART(ISO_WEEK, order_date) AS WeekNumber,
              YEAR(order_date) AS Year,
              COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales1
GROUP BY DATEPART(ISO_WEEK, order_date),
              YEAR(order_date)
ORDER BY Year, WeekNumber

--MONTHLY TREND

SELECT DATEPART(MONTH, order_date) AS Month,
       COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales1
GROUP BY DATEPART(MONTH, order_date)
ORDER BY Month

--PERCENTAGE OF PIZZA SALES BY CATEGORY

SELECT pizza_category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS Sales_total,
       CAST(SUM(total_price) * 100/(SELECT SUM(total_price)
                                    FROM pizza_sales1) AS DECIMAL (10,2)) AS percentage_of_sales
FROM pizza_sales1
GROUP BY pizza_category 
ORDER BY pizza_category DESC

--Additionally if we are to query by month
--WHERE Month is indicated by number e.g. January = 1:

SELECT pizza_category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS Sales_total,
       CAST(SUM(total_price) * 100/
	                        (SELECT SUM(total_price)
	                         FROM pizza_sales1
		                     WHERE MONTH(order_date) = 1)AS DECIMAL (10,2)) AS percentage_of_sales
FROM pizza_sales1
WHERE MONTH(order_date) = 1
GROUP BY pizza_category 
ORDER BY Sales_total DESC

--PERCENTAGE OF SALES BY PIZZA SIZE

SELECT pizza_size,
             CAST(SUM(total_price) AS DECIMAL(10,2)) AS Sales_total,
             CAST(SUM(total_price) * 100/
			                    (SELECT SUM(total_price)
                                 FROM pizza_sales1) AS DECIMAL (10,2)) AS percentage_of_sales
FROM pizza_sales1
GROUP BY pizza_size 
ORDER BY percentage_of_sales DESC

--TOTAL PIZZAS SOLD BY CATEGORY

SELECT pizza_category,
       SUM(quantity) AS Pizzas_sold_total
FROM pizza_sales1
GROUP BY pizza_category
ORDER BY Pizzas_sold_total DESC

--TOP 5 BEST SELLERS BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
--A. BY REVENUE

SELECT TOP 5 pizza_name,
       SUM(quantity) AS total_pizza_sold
FROM pizza_sales1
GROUP BY pizza_name
ORDER BY total_pizza_sold DESC

--B. BY TOTAL QUANTITY

SELECT Top 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales1 
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC

--C. TOTAL ORDERS

SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales1
GROUP BY pizza_name 
ORDER BY Total_Orders DESC

--BOTTOM 5 SELLERS BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
--A. BY REVENUE

SELECT TOP 5 pizza_name,
       SUM(quantity) AS total_pizza_sold 
FROM pizza_sales1
GROUP BY pizza_name
ORDER BY total_pizza_sold ASC

--B. BY TOTAL QUANTITY

SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales1
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC

--C: BY TOTAL ORDERS

SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales1
GROUP BY pizza_name
ORDER BY Total_Orders ASC








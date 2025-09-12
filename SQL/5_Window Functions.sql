--GROUP BY functions
-- AGGREGATE Functions: COUNT(), SUM(), AVG(), MIN(), MAX()

--WINDOW functions
-- AGGREGATE Functions: COUNT(), SUM(), AVG(), MIN(), MAX()
-- RANK Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), CUME_DIST(), PERCENT_RANK(), NTILE(n)
-- VALUE: LEAD(expr, offset, default), LAG(expr, offset, default), FIRST_VALUE(expr), LAST_VALUE(expr)

SELECT *
FROM Sales.Orders

--HIGHEST LEVEL OF AGGREGATION - SUM
SELECT
SUM(Sales) TotalSales
FROM Sales.Orders

--Find the total sales for each product (granularity)
--Additionally provide details such order Id, order date
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY OrderID, OrderDate,ProductID

--GROUP BY LIMITS: Can't do aggregations and provide details at the same time 9:31

--WINDOW FUNCTION - PARTITION BY IS LIKE GROUP BY
--Grouping the data by productID level

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders
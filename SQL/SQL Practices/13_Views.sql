--View: is a virtual table based on the result set of a query, without storing the data in database.
--Views are persisted SQL queries in the database.

--DDL(Data Definition Language): A set of commands that allows us to define and manage the structure of a database.
--CREATE, ALTER, DROP

--Physical level: lowest level of db, stored in physical(internal) storage/layer (DBA)
	--Data files, partitions, logs, catalog, blocks, caches

--Logical level: How to organize your data. (App Developer/Data engineer) -Conceptual layer
	--tables, relationships, views, indexes, procedures, functions

--View level: Highest level of abtraction. 
	--Different views for groups -> Business analysts, Power BI, End Users..-external layer

--Table - Physical table (Real Data) <-> Virtual Table (Abstr layer) <- Query (you)

--Views: No Persistance, easy to maintain, slow response, read only
--Table: Persisted Data, hard to maintain, fast response, read/write

--Why we need view? to store central, complex query logic in the database for access by multiple queries, reducing project complexity.

--find the running total of sales for each month

WITH CTE_Monthly_Summary AS (
	SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate) 
)
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary

--right way to make a view
/*CREATE VIEW Sales.V_Monthly_Summary AS
(
SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate) 
)*/

--To drop
/*DROP VIEW V_Monthly_Summary*/

--SQL -- You have to drop the view first and then recreate the view
--if you want to do it together (drop and create) - you have to use T-SQL: Transact-SQL is an extension of SQL that adds programming features

/*IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Monthly_Summary;
GO */

--A View is stored in the database catalog/schema (metadata) - Query + Metadata when you drop a view
--View Use Case: Views can be use to hide the complexity of database tables and offers users more friendly and easy-to-consume objects.

--TASK: Provide view that combines details from orders, products, customers, and employees

/*CREATE VIEW Sales.V_Order_Details AS (
	SELECT 
	o.OrderID,
	o.OrderDate,
	p.ProductID,
	p.Category,
	COALESCE(c.FirstName,'') + '' + COALESCE(c.LastName,'') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName,'') + '' + COALESCE(e.LastName,'') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	on o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	on c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	on e.EmployeeID = o.SalesPersonID
) */

--View Use Case #3: Use views to enforce security and protect sensitive data, by hiding columns and/or rows from tables.

--Provide a view for EU Sales Team that combines details from All tables and excludes Data related to the USA
/*CREATE VIEW Sales.V_Order_Details_EU AS(
SELECT 
	o.OrderID,
	o.OrderDate,
	p.ProductID,
	p.Category,
	COALESCE(c.FirstName,'') + '' + COALESCE(c.LastName,'') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName,'') + '' + COALESCE(e.LastName,'') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	on o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	on c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	on e.EmployeeID = o.SalesPersonID
	WHERE c.Country != 'USA'
	) */

--#4 USE CASE: Flexibility & Dynamic
--#5 MULTIPLE Languages
--#6 Virtual Data Marts in DWH(Data Warehouse)







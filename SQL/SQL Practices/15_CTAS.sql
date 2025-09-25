--CTAS - CREATE TABLE AS SELECT -
--Create a new table based on the result of an SQL query.

--CREATE/INSERT
--#1 STEP: CREATE: You define an empty table (columns,datatypes).
--#2 STEP INSERT: You load data into it (e.g., from a CSV or another source)

--vs.

--CTAS
--#1 STEP: QUERY -> You run a SELECT query to get some result set.
--CTAS (CREATE TABLE AS SELECT) -> Directly turns that query result into a new table with data already inside.
--shortcut: no separate CREATE + INSERT - it's on step.

--Use a View if you want live, always-up-to-date data.
--Use CTAS if you want a frozen copy you can query fast or transform further.
--View --> dynamic (live data, slower if query is complex).
--CTAS table --> static (snapshot data, faster to query).
--That’s the core difference: freshness vs performance.

-- CTAS Syntax

--MySQL, Postgres, Oracle
-- CREATE TABLE NAME AS 
--(
--SELECT
--FROM
--WHERE
--)
--Sql server
-- SELECT ...
-- INTO New-Table
--FROM ...
--WHERE ...

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL --refresh table by dropping and creating
	DROP TABLE Sales.MonthlyOrders; --drop table
GO
SELECT
DATENAME(month, OrderDate) OrderMonth,
COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate) 

--Common case, snapshot of data specific time
--DTW -> Data Marts (T)

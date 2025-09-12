/*SET OPERATORS*/
--#1 Rule|SQL Clauses
-- Set Operator can be used almost in all clauses
-- WHERE|JOIN|GROUPBY|HAVING
-- ORDER BY is allowed only once at the end of query

--#2 Rule|Number of columns
-- The number of columns in each query must be the same

SELECT
FirstName,
LastName
FROM Sales.Customers

UNION

SELECT
FirstName,
LastName
FROM Sales.Employees

--#3 Rule|Date Types
-- Data types of columns in each query must be compatible
SELECT
CustomerID,
LastName
FROM Sales.Customers

UNION

SELECT
EmployeeID,
LastName
FROM Sales.Employees

-- #4 Rule|Order of Columns (must be the same)

-- #5 Rule|Column Aliases
-- The column names in the result set at determined by the column names specified in the first query
SELECT
CustomerID AS ID,
LastName
FROM Sales.Customers

UNION

SELECT
EmployeeID,
LastName
FROM Sales.Employees

-- #6 Rule|Correct Columns
-- Even if all rules are met and SQL shows no errors, the result may be incorrect.
-- Incorrect column selection leads to inaccurate results.
SELECT
FirstName,
LastName
FROM Sales.Customers

UNION

SELECT
FirstName,
LastName
FROM Sales.Employees


/*UNION*/
-- Returns all district rows from both queries
-- Removes duplicate rows from the result

SELECT
FirstName,
LastName
FROM Sales.Customers

UNION

SELECT
FirstName,
LastName
FROM Sales.Employees

/*UNION ALL*/
-- Returns all rows from both queries, including duplicates
-- UNION ALL is generally faster than UNION

SELECT
FirstName,
LastName
FROM Sales.Customers

UNION ALL

SELECT
FirstName,
LastName
FROM Sales.Employees

/*EXCEPT (Minus)*/
-- Returns all distinct rows from the first query that are not foun din the second query.
-- It is the only one where the order of queries affects the final result.

--Find the employees who are not customers at the same time
SELECT
FirstName,
LastName
FROM Sales.Customers
EXCEPT
SELECT
FirstName,
LastName
FROM Sales.Employees

/*INTERSECT*/
--Returns only the rows that are common in both queries (duplicates)

SELECT
FirstName,
LastName
FROM Sales.Customers
INTERSECT
SELECT
FirstName,
LastName
FROM Sales.Employees

/*COMBINE INFORMATION*/

--Combine similar information before analyzing the data
--Orders data are stored in separate tables (Orders and OrderArchive).
-- Best Pratices: Never use an asterisk(*) to combine tables; list needed columns instead
--Right Click --Select top 1000 rows

SELECT
'Orders' AS SourceTable
,[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.Orders
UNION
SELECT
'OrdersArchive' AS SourceTable
,[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID


/*DELTA DETECTION*/
-- Identifying the differences or changes (delta) between two batches of data
-- EXCEPT operator can be used to compare tables to detect discrepancies between databases.





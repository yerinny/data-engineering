--SUBQUERY

--WHEN?

--STEP 4: AGGREGATIONSm
--STEP 3: TRANFORMATIONS
--STEP 2: FILTERING
--STEP 1: JOIN TABLES


-- Result Types
	-- Scalar subquery: single value 
		--SELECT
		--AVG(Sales)
		--FROM Sales.Orders
	-- Row subquery
		--Multiple Rows + Single Column
		--SELECT
		--CustomerID
		--FROM Sales.Orders
	-- Table subquery
		--Multiple Rows + Multiple Column
		--SELECT
		--OrderID
		--OrderDate
		--FROM Sales.Orders

-- Location|Clauses
	--SELECT
	--Show the product IDs, product names, prices, and the total number of orders
	--Main Query
		SELECT
			ProductID,
			Product,
			Price,
			(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
		FROM Sales.Products


	--FROM: Used as temporary table for the main query
		-- SELECT column1, column2
		-- FROM ( SELECT column FROM table1 WHERE condition ) AS alias
			--Task: Find the products that have a price higher than the avg price of all products
			--Main query
			SELECT 
			*
			FROM
			--Subquery
				(SELECT
				ProductID,
				Price,
				AVG(Price) OVER() AvgPrice
				FROM Sales.Products)t
			WHERE price > AvgPrice
		-- Rank Customers based on their total amount of sales
			SELECT
			*,
			RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
			FROM
				--subquery
				(SELECT
				CustomerID,
				SUM(Sales) TotalSales
				FROM Sales.Orders
				GROUP BY CustomerID)t

	--JOIN
	-- Show all customer details and find the total orders of each customer
	
	--Main query
	SELECT
	*
	FROM Sales.Customers c
	LEFT JOIN(
		SELECT
		CustomerID,
		COUNT(*) TotalOrders
		From Sales.Orders
		GROUP BY CustomerID) o
	ON c.CustomerID = o.CustomerID

	--WHERE
		/*  Comparison operators: < > = != >= <= */
		-- Logical operators: IN, ANY, ALL, EXISTS
	
	--Find the products that have a price higher than the average price of all products
	
	--Main Query
	SELECT
	ProductID,
	Price
	FROM Sales.Products
	WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

--show the details of orders made by customers in Germany

--Main Query
SELECT
*
FROM Sales.Orders
WHERE CustomerID IN
				(SELECT 
				CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany')

--Find female employees whos salaries are greater than the salaries of any male employees

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M') --ALL and ANY could be used

SELECT FirstName, Salary FROM Sales.Employees WHERE Gender = 'M';

--ALL OPERATOR
--Find female employees

-- Dependency
-- Non-Correlated subquery: A Subquery that can run independently from the Main Query
	--Executed once and its result is used by the main query
	--Can be executed on its Own
	--Easier to read
	--Execute only once leads to better performance
	--static comparison, filtering with constants

SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c


-- Correlated subquery: A Subquery that relays on values from the Main Query
	--Executed for each row processed by the main query
	--Can't be executed on its Own
	--Harder to read and more complex
	--Executed multiple times leads to bad performance
	--row-by-row comparisons, dynamic filtering 

--EXISTS OPERATOR
--show the deteails of orders made by customer in Germany

--Main Query
SELECT 
* 
FROM Sales.Orders o
WHERE EXISTS (
			SELECT *
			FROM sales.Customers c
			WHERE Country = 'Germany'
			AND o.CustomerID = c.CustomerID) 



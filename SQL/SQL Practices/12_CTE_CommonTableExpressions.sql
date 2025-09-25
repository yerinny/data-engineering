--CTE(Common Table Expression): Temporary, named result set (virtual table), that can be used multiple times within your query to simplify and organize complex query.

--Subquery(bottom to top) vs. CTE(top to bottom)
-- in the subquery, result can be only used once
-- CTE, use virtual table, you can use it in many places(FROM and JOIN and JOIN)



--STEP 4 AGGREGATIONS(AVG) -- Main query
--STEP 3              JOIN -- sub query
--STEP 2 AGGREGATIONS(SUM) -- sub query
--STEP 1              JOIN -- sub query  --this is problem, redundancy

--Solution (CTE)
--STEP 1 JOIN			   -- reuse this step -- CTE Query -- MAIN QUERY
--STEP 2 AGGREGATION (SUM)
--STEP 3 AGGREGATION (AVG)

--CTE QUERY --> Broken down, readability increases, modularity increases, reusability

--WITH CTE-Name AS
--(
--SELECT...
--FROM...
--WHERE...
--)

--SELECT ...
--FROM CTE-Name
--WHERE...

--CTE TYPES
--Non-Recursive CTE
	--Standalone CTE: Defined and Used independently. Runs independently as it's self-contained and doesn't rely on other CTEs or queries.
		-- DB <-> CTE -> Intermediate <-> Main query -> Final
		-- Step1: Find the total Sales Per Customer
		WITH CTE_Total_Sales AS
		(
		SELECT
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID
		)
		--Main Query
		SELECT
		c.CustomerID,
		c.FirstName,
		c.LastName,
		cts.TotalSales
		FROM Sales.Customers c
		LEFT JOIN CTE_Total_Sales cts
		ON cts.CustomerID = c.CustomerID
		-- CTE-RULE: You cannot use ORDER BY directly within the CTE

		--Multiple standalone CTEs
		--WITH CTE-Name1 AS
		--(
			--SELECT...
			--FROM...
			--WHERE...
		--)
		--, CTE-Name 2 AS
		--(
			--SELECT...
			--FROM...
			--WHERE...
		--)

		--Main Query
		--SELECT ..
		--FROM CTE-Name1
		--JOIN CTE-Name2
		--WHERE ...

		--Step2: Find the last order date per customer
		WITH CTE_Total_Sales AS
		(
		SELECT
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID
		)
		,CTE_Last_Order AS
		(
		SELECT 
			CustomerID,
			MAX(OrderDate) AS Last_Order
		FROM Sales.Orders
		GROUP BY CustomerID
		)
		--Main Query
		SELECT
		c.CustomerID,
		c.FirstName,
		c.LastName,
		cts.TotalSales,
		clo.Last_Order
		FROM Sales.Customers c
		LEFT JOIN CTE_Total_Sales cts
		ON cts.CustomerID = c.CustomerID
		LEFT JOIN CTE_Last_Order clo
		ON clo.CustomerID = c.CustomerID

	--Nested CTE: CTE inside another CTE. A nested CTE uses the result of another CTE, so it can't run independently
	--DB <-> CTE #1 -> Intermediate <-> CTE #2 -> Intermediate(final) <-> Main QUERY -> Final result
		--WITH CTE-Name1 AS
		--(
			--SELECT...
			--FROM...
			--WHERE...
		--)
		--, CTE-Name 2 AS
		--(
			--SELECT...
			--FROM CTE-Name 1
			--WHERE...
		--)
		--Main Query
		--SELECT ..
		--FROM CTE-Name2
		--WHERE ...

	--Step3: Rank Customers based on Total Sales Per Customer
	--Main Query
		WITH CTE_Total_Sales AS
		(
		SELECT
			CustomerID,
			SUM(Sales) AS TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID
		)
		--Step 2:Find the last order date for each customer (Standalone CTE)
		,CTE_Last_Order AS
		(
		SELECT 
			CustomerID,
			MAX(OrderDate) AS Last_Order
		FROM Sales.Orders
		GROUP BY CustomerID
		)
		--Step 3: Rank Customers based on Total Sales Per Customer
		 , CTE_Customer_Rank AS
		 (
		 SELECT
		 CustomerID,
		 TotalSales,
		 RANK() OVER (ORDER BY TOtalSales DESC) AS CustomerRank
		 FROM CTE_Total_Sales
		 )
		 --Step4: Segment customers based on their total sales
		--Main Query
		SELECT
		c.CustomerID,
		c.FirstName,
		c.LastName,
		cts.TotalSales,
		clo.Last_Order,
		ccr.CustomerRank
		FROM Sales.Customers c
		LEFT JOIN CTE_Total_Sales cts
		ON cts.CustomerID = c.CustomerID
		LEFT JOIN CTE_Last_Order clo
		ON clo.CustomerID = c.CustomerID 
		LEFT JOIN CTE_Customer_Rank ccr
		ON ccr.CustomerID = c.CustomerID 


--Recursive CTE: self-refreshing query that repeatedly processes data until a specific condition is met.

--Generate a Sequence of Numbers from 1 to 20

WITH Series AS (
	--Anchor Query
	SELECT
	1 AS MyNumber
	UNION ALL
	--Recursive Query
	SELECT
	MyNumber + 1 --current value + 1
	FROM Series
	WHERE MyNumber < 20
)
--Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 1000)
		
--Start -> RUN Anchor Query -> Run Recursive Query <- True My Number < 20? -> False -> END

--Task: Show the employee hierarchy by displaying each employee's level within the organization

WITH CTE_Emp_Hierarchy AS
(
	-- Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level  
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL
	--Recursive Query
	SELECT 
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level +1
	FROM Sales.Employees AS e
	INNER JOIN CTE_Emp_Hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
)

--Main Query
SELECT
*
FROM CTE_Emp_Hierarchy
--GROUP BY functions
-- AGGREGATE Functions: COUNT(), SUM(), AVG(), MIN(), MAX()

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

--WINDOW functions
-- AGGREGATE Functions: 
	--COUNT():All Data Type
	--SUM(): Numeric
	--AVG(): Numeric
	--MIN(): Numeric
	--MAX(): Numeric
-- RANK Functions: 
	--ROW_NUMBER(): Empty
	--RANK(): Empty
	--DENSE_RANK(): Empty
	--CUME_DIST(): Empty
	--PERCENT_RANK(): Empty
	--NTILE(n): Numeric
-- VALUE(analytic functions): 
	--LEAD(expr, offset, default): All Date Type
	--LAG(expr, offset, default): All Date Type
	--FIRST_VALUE(expr): All Date Type
	--LAST_VALUE(expr): All Date Type

/* Window Fuction - Over Clause: Partition Clause | Order Clause | Frame Clause */
/* OVER CLAUSE tells SQL that the function used is a window function 
It defines a swindow or subset of data */

--AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)
	
	--AVG(Sales): Calculation used on the Widnow
		-- Sales: Function expression
			-- OVER ('''''): Define the window:Over Clause
				-- PARTITION BY: Divides the result set into partitions (Windows)
				-- SUM(Sales) OVER(): if used empty; Calculation is done on entire dataset
				-- SUM(Sales) OVER(PARTITION BY Product): Window 1 Window 2: Calculation is done individually on each window
				-- Without: Total sales across all rows (Entire result set): SUM(Sales) OVER ()
				-- Partition By Single Column: SUM(Sales) OVER (PARTITION BY Product)
				-- Partition By Combined-Columns: Total sales for each combination of Product and Order Status: SUM(Sales) OVER (PARTITION BY PRoduct, OrderStatus)

/*Find the total sales across all orders
Find the total sales for each product
Find the total sales for each combination of product and order status
Additionally provide details such order Id, order date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus
	Sales,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders
                      
					 -- ORDER BY: Sort the data within a window (ASC|DESC)

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders
						--ROWS UNBOUNDED PRECEDING: Frame Clause: Define a subset of rows within each window that is relevant for the calculation

--AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate
--	ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING)
	-- Frame Types: ROWS, RANGE
	-- Frame Boundary(lower value): CURRENT ROW, N PRECEDING, UNBOUNDED PRECEDING
	-- Frame Boundary(Higher value): UNBOUNDED PRECEDING, CURRENT ROW, N FOLLOWING

--**RULES: Frame Clause can only be used together with order by clause
-- Lower Value must be BEFORE the higher Value.

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)

		--N-FOLLOWING: The n-th row before the current row
		--If data starts with Month Jan in the row, that's the current row
		--and feb and mar in the next two rows are the 2 Followings -- it adds the values of those 3
		--slides down by 1 and add 3 again

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
		-- UNBOUNDED FOLLOWING: The last possible row within a window

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
		-- N-PRECEDING: The n-th row before the current row

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
		--UNBOUNDED PRECEDING: The first possible row within a window

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)

-- SUM(Sales)
-- OVER (ORDER BY Month
-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ** ALWAYS EVERYTHING 

--**ORDER BY ALWAYS USES FRAME
SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW and 2 FOLLOWING) TotalSales
FROM Sales.Orders

--#1 RULE: Window functions can be used ONLY in SELECT and ORDER BY Clauses
--#2 RULE: Nesting Widow Functions is not allowed
--#3 RULE: 

-- Find the total sales for each order status, only for two products 101 and 102.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101,102)

--WHERE CLAUSES executed than SUM; FILTER FIRST THEN AGGREGATION

--#4 RULE: Window Function can be used together with GROUP BY in the same query, ONLY if the same columns are used

--Rank Customers based on their total sales
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID

--*NOTE: Use GROUP BY for simple aggregations
-- STEP 1: Add GROUP BY to the query
-- STEP 2: Add WINDOW function ot the query
--WINDOW FUNCTIONS 
-- COUNT, AVG, SUM, MAX, MIN

--AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales)
	--AVG(Sales): Expression is required
	--PARTITION BY: Optional
	--ORDER BY Sales: Optional

--COUNT(*) OVER (PARTITION BY Product)
--**VERY CAREFUL WITH NULL VALUES** - counts all rows even NULLS
--instead of * --> COUNT(Sales) OVER (PARTITION BY Product)

--Find the total number of Orders
--Additionally provide details such order id, order date
--Additionally provide All customer Details
SELECT
*,
COUNT(*) OVER() TotalCustomers,
COUNT(Score) OVER() TotalScores
FROM Sales.Customers

--Check whether the table 'orders' contains any duplicate rows
SELECT *
FROM (
	SELECT
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
) t WHERE CheckPK > 1

--2 orders with same product ID and key 


--Find the average sales across all orders and the average sales for each product

SELECT
OrderID,
OrderDate,
Sales,
ProductID,
AVG(Sales) OVER () AvgSales,
AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProducts
From Sales.Orders

--Find the average scores of customers
-- Additionally provide details such CustomerID and LastName
--**COALESCE

SELECT
CustomerID,
LastName,
Score,
COALESCE(Score,0) CustomerScore,
AVG(Score) OVER() AvgScore,
AVG(COALESCE(Score,0)) OVER ()AvgScoreWithoutNull
FROM Sales.Customers

--Find all orders where sales are higher than the average sales across all orders
--** Window functions can't be used in the WHERE Clause, so we use subquery

SELECT
* 
FROM (
SELECT
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER() AvgSales
FROM Sales.Orders
)t WHERE Sales > AvgSales

--Show the employees who have the highest salaries

SELECT
* 
FROM (
	SELECT *,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
) t WHERE Salary = HighestSalary


SELECT *,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees

--Find the deviation of each sales from the min and max sales amounts
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	Min(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders

--RUNNING & ROLLING TOTAL: They aggregate sequence of members and the aggregation is updated each time a new member is added
	--RUNNING TOTAL: Aggregate all values from the beginning up to the current point without dropping off older data.
		--SUM(Sales) OVER(ORDER BY MONTH)
		-- default: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

	--ROLLLING TOTAL: Aggregate all values within a fixed time window (e.g. 30 days). As new data is added, the oldest data point will be dropped.
		--SUM(Sales) OVER( ORDER BY MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

--TRACKING: Tracking Current Sales with Target Sales
--TREND ANALYSIS: Providing insights into historical patterns

--Calculate moving average of sales for each product over time
--Calculate moving average of sales for each product over time, including only the next order

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders














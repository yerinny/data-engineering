--SQL VALUE WINDOW FUNCTIONS

--Expression: All Data Type
--PARTITION Clause: Optional
--ORDER Clause: Require
-- FRAME Clause: LEAD, LAG - not allowed, FIRST_VALUE - Optional, LAST_VALUE - should be used

-- LEAD(expr, offset, default): Access a value from the next row within a window.
	--LEAD(Sales, 2, 10) OVER (PARTITION BY ProductID ORDER BY OrderDate)
	--exp: any data type, offset: number of rows fwd or bwd from current row
	--default: returns default value if next/previous row is not available, default = NULL
--LAG(expr, offset,default): Access a value from the previous row within a window.
	--LAG(Sales, 2, 10) OVER (PARTITION BY ProductID ORDER BY OrderDate)


--LEAD/LAG good for TIME SERIES ANALYSIS: The process of analyzing the data to understand patterns, trends, and behaviros over time.
	--Year-over-Year (YoY): Analyze the overall growth or decline of the business's performance over time
	--Month-over-Month(MoM): Analyze short-term trends and discover patterns in seasonality

--Analyze the mont-over-month performance by finding the pcerntage change in sales between the current and previous months
SELECT
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/ PreviousMonthSales *100, 1) AS MoM_Perc
FROM (
SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY
	MONTH(OrderDate)
)t

--In order to analyze customer loyalty, rank customers based on the average days between their orders

SELECT
CustomerID,
AVG(DaysUntilNextOrder) AvgDays,
RANK() OVER (ORDER BY COALESCE( AVG(DaysUntilNextOrder), 999999)) RankAvg
FROM (
	SELECT
	OrderID,
	CustomerID,
	OrderDate CurrenOrder,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(day, OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders

) t
GROUP BY 
	CustomerID


--FIRST_VALUE(expr)
--LAST_VALUE(expr)

--Find the lowest and highest sales for each product
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ASC) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSale2,
	MIN(Sales) OVER (PARTITION BY ProductID) LowestSales2,
	MAX(Sales) OVER (PARTITION BY ProductID) HighestSales3
FROM Sales.Orders

--Find the difference in sales between the current and the lowest sales.

SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ASC) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ASC) AS SalesDifference
FROM Sales.Orders
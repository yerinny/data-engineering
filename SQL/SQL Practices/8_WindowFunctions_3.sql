/* SQL RANKING WINDOW FUNCTIONS - ROW_NUMBER, RANK, DENSE_RANK, NTILE */

--RANK() OVER(PARTITION BY ProductID ORDER BY Sales)
	--PARTITION BY IS OPTIONAL, ORDER BY required

--TOP/BOTTOM N Analysis (discrete value)
	--ROW_NUMBER(): Assign a unique number to each row, it doesn't handle ties. Rank the orders based on their sales from highest to lowest
	--RANK():Assign a rank to each row, it handles ties.
	--DENSE_RANK(): Assign a rank to each row. It handles ties. It doesn't leaves gaps in ranking.
	--NTILE(): Divides the rows into a specified number of approx. equal groups (Buckets)

SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SaleRank_Row, --Unique Rank/does NOT handle ties/no gaps in ranks
RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank, -- Shared Rank/ handles ties/ gaps in ranks
DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_Dense  -- Shared Rank/ handles ties/no gaps in ranks
FROM Sales.Orders

--TOP-N Analysis
--Find the top highest sales for each product
--In order to filter the data from ^ you want to use subqueries

SELECT *
FROM (
SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM Sales.Orders
) t WHERE RankByProduct = 1

--BOTTOM-N Analysis
--Find the lowest 2 customers based on their total sales
SELECT *
FROM(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers --if you use GROUPBY you have to use ORDER BY
FROM Sales.Orders
GROUP BY
CustomerID
) t WHERE RankCustomers <=2

--Assign unique IDs to the row of the 'OrderArchive' table
SELECT
ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
* 
FROM Sales.OrdersArchive

--Identify duplicate rows in the table 'Orders Archive'
-- and return a clean result without any duplicate
SELECT * FROM (
SELECT
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
* 
FROM Sales.OrdersArchive
) t WHERE rn = 1

SELECT
OrderID,
Sales,
NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
NTILE(1) OVER (ORDER BY Sales DESC) OneBucket
FROM Sales.Orders

--**USE CASE**: Data Segmentation - Equalizing load processing (load balancing)
SELECT
*,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'low'
	 END SalesSegmentation
FROM (
SELECT
	OrderID,
	Sales,
	NTILE(3) OVER (ORDER BY Sales DESC) Buckets
FROM Sales.Orders
)t

--In order to export the data, divide the orders into 2 groups
SELECT
NTILE(2) OVER (ORDER BY OrderID) Buckets,
*
FROM Sales.Orders


--DISTRIBUTION ANALYSIS (continuous values)
-- CUME_DIST(): Cumulative Distribution calculates the distribution of data points within a window
	-- CUME_DIST() OVER (ORDER BY Sales DESC)
	-- Inclusive (The current row is included)
--PERCENT_RANK(): Calculates the relative position of each row 
	-- PERCENT_RANK() OVER (ORDER BY Sales DESC)
	-- Exclusive 

-- Find the products that fall within the highest 40% of the prices
SELECT 
*,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM(
SELECT
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) DistRank
FROM Sales.Products
) t WHERE DistRank <= 0.4


/* CASE STATEMENT
Evaluates a list of conditions and returns a value when the first condition is met */

/* CATEGORIZING DATA */

/* Create report showing total sales fro each of the following categories:
	High (Sales over 50), Medium (sales 21-50), and Low (sale 20 or less)
	Sort the categories from highest sales to lowest */

SELECT
Category,
SUM(Sales) AS TotalSales
FROM(
	SELECT
	OrderID,
	Sales,
	CASE	
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END Category
	FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC

--RULE: CASE STATEMENT HAS TO USE SAME DATA TYPES ex: if string then all string matching

/*MAPPING VALUES*/
--Retrieve employee details with gender displayed as full text

SELECT 
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
	WHEN Gender = 'F' THEN 'Female'
	WHEN Gender = 'M' THEN 'Male'
	Else 'Not available'
END GenderFullText
FROM Sales.Employees

--Retrieve customers details with abbreviated country code
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'n/a'
	END CountryAbbr
FROM Sales.Customers

--Possible values
SELECT DISTINCT Country
FROM Sales.Customers;

/*Quick Form*/

/*
CASE Country
	WHEN 'Germany' THEN 'DE'
	WHEN 'India' THEN 'IN'
	WHEN 'United States' THEN 'US'
	ELSE 'n/a'
END 
*/

/*HANDLING NULLS*/

--Find the average scores of customers and treat Nulls as 0
--Additionally provide details such  Customer ID and LastName
SELECT 
CustomerID,
LastName,
Score,
CASE
	WHEN Score IS NULL THEN 0
	ELSE Score
END ScoreClean,

AVG(CASE
	WHEN Score IS NULL THEN 0
	ELSE Score
END) OVER () AvgCustomerClean,

AVG(Score) OVER() AvgCustomer
FROM Sales.Customers

/* CONDITIONAL AGGREGATION */

--Apply aggregate functions only on subsets of data that fulfill certain conditions
--Count how many times each customer has made an order with sales greater than 30.
--*FLAG: Binary indicator (1,0) to be summarized to show how many times the condition is true

SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrdersHighSales,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID



-- Day 1: Practicing JOINs
-- JOINs (Columns) 
-- INNER, LEFT, FULL "Combine Data - Big Picture"
-- LEFT "Date Enrichment - Extra info"
-- INNER, LEFT+WHERE, RIGHT+WHERE "Check Existence - Filtering"

--NO JOIN
SELECT * FROM dbo.customers;
SELECT * FROM dbo.orders;

--INNER JOIN
SELECT * 
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id

--LEFT JOIN
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

--RIGHT JOIN
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

--FULL JOIN
SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

--Basically opposite of above
--LEFT ANTI JOIN
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--RIGHT ANTI JOIN
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

--FULL ANTI JOIN
SELECT * 
FROM orders AS o
FULL JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

--ANTI INNER JOIN
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.order_id IS NOT NULL

--CROSS JOIN
SELECT
	o.OrderID,
	o.sales,
	c.FirstName,
	c.LastName,
	p.Product AS ProductName,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID














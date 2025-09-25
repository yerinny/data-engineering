--What is Stored Procedure?

/*
A stored procedure is like a saved recipe of SQL code that lives inside the database.

Definition: A stored procedure is a set of SQL statements that you store in the database and can run (execute) whenever you want.

Purpose: Instead of writing the same queries again and again, you save them once and just call the procedure by name.

Inputs/Outputs: You can pass parameters into it (like arguments to a function) and sometimes get results back.

Benefits:
Reusable (write once, run many times)
Faster (precompiled by the database)
Easier to maintain (change logic in one place)
More secure (control access through procedures instead of exposing raw tables)

This diagram shows the difference between a stored procedure and a simple query:
Stored Procedure (left side)
Acts like a program inside the database.
Can include loops, control flow (if/else), parameters, and error handling.
Can run multiple SQL operations (INSERT, UPDATE, SELECT, etc.) in one packaged block.
Talks directly with the database, sending and receiving results.

Query (right side)
A single SQL request (e.g., SELECT ... FROM ... WHERE ...).
Runs once, does only what’s written.
No logic like loops or error handling—it’s just a statement.

In short:
A query is one request.
A stored procedure is like a mini-program that can run many queries with logic, parameters, and error handling.


Stored Procedure (in the DB server)
Pre-compiled / plan-cached -> runs faster; DB optimizes once and reuses the plan.
Lives closeto the data -> fewer network round-trips.
Packs multiple SQL ops (INSERT, UPDATE, SELECT) with transactions & permissions.
Downsides: less flexible for complex app logic; harder to version like code.

Python / App Server (outside the DB)
Not pre-compiled (interpreted/VM) -> more overhead per call; more network chatter.
Very flexible: rich libraries, orchestration, external API calls, complex logic.
Easy version control and testing.
Must manage connections, errors, and performance carefully.

From Python, you can still call the stored procedure using a DB connector (e.g., pyodbc, psycopg2, mysql-connector).
Example (Python calling a stored procedure):

cursor.callproc("GetOrdersByCustomer", [101])

The stored procedure still executes in the DB engine, not in Python.
So: you can’t reuse the compiled procedure in Python itself.

Trade-off:
Use stored procedures for performance-critical, data-centric routines; use Python for complex, cross-system logic and maintainability.
*/

/* Procedure Syntax
CREATE PROCEDURE ProcedureName AS
BEGIN
---SQL STATEMENTS GO HERE
END

EXEC ProcedureName
*/

--USE SalesDB
--Step 1: Write a Query
--For US Customers Find the Total Number of Customers and the Average Score

SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'


--Step 2: Turning the Query Into a Stored Procedure
--Defin Store Procedure

--Total Customers from Germany: 2
--Average Score from Germany: 425

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;
		
		--===============================
		-- Step 1:Prepare & CLeanup Data
		--===============================
		IF EXISTS(SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN 
			PRINT('Updating NULL Scores to 0')
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT('No NULL Scores found')
		END;

		--==================================
		--Step 2: Generating Summary Reports
		--==================================
		--Calcualte Total Customers and Average Score for specific Country
		SELECT
			@TotalCustomers  = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from '  + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from '  + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

		--Calculate Total Number of Orders and Total Sales for specific Country
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales,
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;

	END TRY
	BEGIN CATCH
		--==============
		--Error Handling
		--==============
		PRINT('An error occured.');
		PRINT('Error Message:' + ERROR_MESSAGE() );
		PRINT('Error Message:' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line:' + CAST(ERROR_LINE() AS NVARCHAR) );
		PRINT('Error Procedure.' + ERROR_PROCEDURE());
	END CATCH
END
GO
--=====================================
--Step3: Execute the Stored Procedure
--=====================================
EXEC GetCustomerSummary;
EXEC GetCustomerSummary @Country = 'Germany';

--DROP PROCEDURE GetCustomerSummaryGermany 

--Find the total Nr. of Orders and Total Sales
SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'

--VARIABLES
--Parameters pass values into a stored procedure or return values back to the caller.
--Vairables temporarily store and manipulate data during its execution

SELECT * FROM Sales.Customers -- handle nulls before aggregating to ensure accurate results

--Error Handling
--BEGIN TRY
--SQL statements that might cause an error
--END TRY

--BEGIN CATCH
--SQL Statements to handle the error
--END CATCH








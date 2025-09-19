--Temporary Tables (System db->tempdb)
--Stores intermediate results in temporary storage within the database during the session.
--The database will drop all temporary tables once the session ends.

--Session: The time between connecting to and disconnecting from the database.

--SELECT...
--INTO #New-Table
--FROM...
--WHERE...

/* #1STEP: Load Data to TEMP Table
 SELECT 
	*
	INTO #Orders
	FROM Sales.Orders 

#2STEP: Transform Data in TEMP Table
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

#3STEP: Load TEMP Table into Permanent Table
SELECT
*
INTO Sales.OrdersTest
FROM #Orders

*/



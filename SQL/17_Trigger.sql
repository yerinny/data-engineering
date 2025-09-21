/*
A trigger in SQL is a piece of code (like a stored procedure) that automatically runs when a specific event happens on a table or view.

Events that can activate a Trigger:
	INSERT -> When new data is added to the table
	UPDATE  ->When existing data is modified
	DELETE  -> When rows are removed

What a Trigger can do:
	Once fired, the trigger can perform different actions, for example:
	INSERT into another table (e.g., logging changes)
	CHECK conditions (validate data before allowing changes)
	WARNING or raise an error if rules are broken

Why use Triggers?
	Enforce business rules automatically
	Maintain data integrity
	Create audit logs (track changes)
	Automate extra tasks without changing the application code

In short:
A trigger is like a watchdog on a table — when something happens (insert, update, delete), it automatically reacts with predefined logic. 
A trigger is like an automatic logging & rule-enforcing procedure that reacts to changes in your database tables.*/

/*
1. DML Triggers (Data Manipulation Language)
Fire when data in a table changes.
Events: INSERT, UPDATE, DELETE

Can be defined as:
AFTER -> runs after the action happens.
INSTEAD OF -> replaces the action with custom logic (often used on views).

2. DDL Triggers (Data Definition Language)
Fire when database objects are modified.

Events: CREATE, ALTER, DROP
Example: Prevent dropping a critical table.

3. LOGON Triggers
Fire when a user connects (logs in) to the database.

Used for:
Security checks
Limiting connections
Auditing login activity

In short:
DML = data changes (rows)
DDL = structure changes (tables, schema, etc.)
LOGON = user login events
*/


--DML
--Trigger syntax

CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,   -- Auto-incrementing unique ID for each log entry
    EmployeeID INT,                        -- References which employee the log belongs to
    LogMessage VARCHAR(255),               -- Message describing the action/event
    LogDate DATE                           -- Date when the event happened
)

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID, 
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR), 
        GETDATE()
    FROM INSERTED
END

/* Key Parts:

AFTER INSERT
-> Trigger fires after a new row is added to Sales.Employees.

INSERTED (virtual table)
-> Holds the new rows that were just inserted.
-> Example: if 3 employees are inserted at once, INSERTED will contain 3 rows.

Action inside trigger
-> Takes each new EmployeeID and writes a log into Sales.EmployeeLogs with:

EmployeeID
Message ('New Employee Added = ...')
Current date/time (GETDATE())

In simple terms:
Whenever you add a new employee, SQL automatically creates a log entry in EmployeeLogs. */

INSERT INTO Sales.Employees
VALUES (7, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3)

SELECT * FROM Sales.EmployeeLogs

--Index: Data structure provides quick access to data, optimizing the speed of your queries
/*
--Heap structure: Table WITHOUT clustered index (Full table scan) - slow
--Data file (.mdf) -> Pages: The smallest unit of data storage in a db (8kb). It stores anything (data, metadata, indexes, etc.)
-- Data page 
	--Header -> FileID -> PageNumber 
-- Index page

==================
1. By Structure
==================
Clustered Index -> Data is stored in the same order as the index.
Only one clustered index per table.
Makes data retrieval faster for range queries.

B-TREE (BALANCE TREE): Hierarchical structure storing data at leaves, to help quickly locate data.
Index Page: It stores key values (Pointers) to another page. It doesn't store the actual rows.

Non-Clustered Index -> Separate structure that points to the data.
You can have multiple non-clustered indexes.
Great for lookup queries on non-primary key columns.

Clustered Index
Defines the physical order of data in the table.
Think of it like a phonebook sorted by last name -> the rows are stored in that order.
Only one clustered index per table (because the table itself can only be stored one way).
Usually created on the primary key.
Fast for range queries and retrieving large chunks of ordered data.
Use case: Unique Column, Not frequently modified column, & Improve range query performance

Non-Clustered Index
A separate structure that stores the index key + a pointer (row locator) to the actual data.
Think of it like an index at the back of a book -> it doesn’t reorder the book, just points you to the right page.
You can have multiple non-clustered indexes per table.
Good for lookups on frequently searched columns.
Use case: Columns frenquently used in search conditions and joins & Exact match queries

Index Syntax:
--default is nonclustered
CREATE [CLUSTERED| NONCLUSTERED] INDEX index_name ON table_name (column1, column2, ...)

CREATE CLUSTERED INDEX IX_Customers_ID ON Customers (ID)
-- Stores table rows physically sorted by ID (one per table).

CREATE NONCLUSTERED INDEX IX_Customers_City ON Customers (City)
-- Separate index on City for faster lookups (multiple allowed).
--Multiple meaning:
Multiple indexes = you can create many different indexes on a table.
Composite index = a single index built on multiple columns.

CREATE INDEX IX_Customers_Name ON Customers (LastName ASC, FirstName DESC) --INDEX is nonclustered
-- Composite non-clustered index on LastName + FirstName (for multi-column search/sort).

*/
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

SELECT 
*
FROM Sales.DBCustomers
WHERE LastName = 'Brown'

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

--Composite Index: Multiple columns in the index
--Leftmost Prefix Rule: Index works only if your query filters start from the first column in the index and follow its order.

SELECT 
*
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score) --must be same order as query


/*
==================
2. By Storage
==================
Rowstore Index -> Stores data row by row (traditional, best for OLTP / transaction-heavy systems).
Columnstore Index -> Stores data column by column (best for analytics, aggregates, and OLAP workloads).

Rowstore (right side)
	Traditional way of storing data.
	Each row is kept together -> ID, Name, Country all stored side by side.
	Example:
		Row1: 1, Bob, USA
		Row2: 2, Anna, Germany
		Row3: 3, Lisa, Italy
	Great for OLTP - Online Transaction Processing (transactional systems) -> inserting, updating, retrieving whole rows quickly.
	Downside: Scanning millions of rows for just one column (e.g., all "Country") is slow.

Columnstore (left side)
	Stores each column separately instead of entire rows.
	Uses dictionary encoding + compression:
		Dictionary Page: assigns small codes ('A' = 1, 'B' = 2).
		Data Stream: stores just codes [1,1,2,2,1,...] instead of repeating values.
	Much more space-efficient.
	Great for OLAP (analytics/warehousing) -> fast aggregations, scanning billions of rows for few columns.

Rowstore = storing resumes as whole documents  -> easy to grab one person’s file.
Columnstore = storing resumes as separate piles (names, addresses, skills)  -> easy to analyze everyone’s skills at once.


clustered-ColumnStore Process

		RowStore Heap Table - is a NO 

		Row Groups -> The rowstore table is divided into chunks (usually ~1M rows per group). 
		Column Segments  -> Each row group is split by columns (ID, Name, Status).
		Compression  -> Column data is compressed for efficiency.

		Store  -> Compressed column segments are saved into LOB (Large Object) pages. - is a YES

non-clustered-ColumnStore Process
		
		RowStore Heap Table - is a YES

		Row Groups -> The rowstore table is divided into chunks (usually ~1M rows per group). 
		Column Segments  -> Each row group is split by columns (ID, Name, Status).
		Compression -> Column data is compressed for efficiency.

		Store  -> Compressed column segments are saved into LOB (Large Object) pages. - is a YES - additional structure
	

==================
3. By Functions
==================
Unique Index -> Ensures values in a column are unique (no duplicates).
Filtered Index -> Index built only on a subset of rows (using a WHERE condition), making it smaller and faster for specific queries.

In short:
Structure = How index relates to table data.
Storage = How data is physically stored.
Functions = Special rules or conditions applied to the index. */

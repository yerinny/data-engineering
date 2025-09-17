--CHALLENGES
	--Redundancy
	--Peformance issues
	--Complexity
	--Hard to Maintain
	--DB Stress
	--Security
--SOLUTIONS
	--Subquery
	--CTE
	--Views
	--Temp Tables
	--CTAS

--SERVER
	--STORAGE
		--DISK STORAGE: Long-term memory, where data is stored permanently
			--+Capacity: can hold a large amount of data
			---Speed: Slow to read and to write
				--3type storage
					--User data storage: it's the main content of the database. This is where the actual data that users care about is stored.
					--System Catalog: Database's internal storage for its own information. A blueprint that keeps track of everything about db itself, not the user data.
						--it holds the Metadata information about the database
						--Information Schema: A system-defined schema with built-in views that provide info about the db like tables and columns.
					--Temporary storage(system db ->Temp db): Temporary space used by the database for short-term tasks, like processing queries or sorting data.
					--Once these tasks are done, the storage is cleared.


		--CACHE STORAGE: Fast short-term memory, where data is stored temporarily.
			--+Speed: extremely fast to read and to write
			---Capacity: can hold smaller amount of data. 


--DATABASE ENGINE: It is the brain of the db, executing multiple operations such as storing, retrieving, and managing data within the db.


-- CLIENT (You are writing SQL for certain purpose)

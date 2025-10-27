--- Create Database 'DataWarehouse'

USE master;

CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
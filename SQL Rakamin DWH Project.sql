-- Akses database ke DWH_Project
USE [DWH_Project];

-- DimCustomer
DROP TABLE IF EXISTS DimCustomer;
CREATE TABLE DimCustomer(
	CustomerID INT NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	NoHP VARCHAR(50) NOT NULL);

SELECT * FROM DimCustomer;
DELETE FROM DimCustomer;

-- DimProduct
DROP TABLE IF EXISTS DimProduct;
CREATE TABLE DimProduct(
	ProductID INT NOT NULL PRIMARY KEY,
	ProductName VARCHAR(255) NOT NULL,
	ProductCategory VARCHAR(255) NOT NULL,
	ProductUnitPrice INT NOT NULL);

UPDATE DimProduct SET ProductName = LOWER(ProductName);
UPDATE DimProduct SET ProductCategory = UPPER(ProductCategory);
SELECT * FROM DimProduct;
DELETE FROM DimProduct;

-- DimStatusOrder 
DROP TABLE IF EXISTS DimStatusOrder;
CREATE TABLE DimStatusOrder(
	StatusID INT NOT NULL PRIMARY KEY,
	StatusOrder VARCHAR(50) NOT NULL,
	StatusOrderDesc VARCHAR(50) NOT NULL);

SELECT * FROM DimStatusOrder;
DELETE FROM DimStatusOrder;

-- tabel Fact FactSalesOrder
DROP TABLE IF EXISTS FactSalesOrder;
CREATE TABLE FactSalesOrder(
	OrderID INT NOT NULL PRIMARY KEY,
	CustomerID INT FOREIGN KEY REFERENCES DimCustomer(CustomerID),
	ProductID INT FOREIGN KEY REFERENCES DimProduct(ProductID),
	Quantity INT NOT NULL,
	Amount INT NOT NULL,
	StatusID INT FOREIGN KEY REFERENCES DimStatusOrder(StatusID),
	OrderDate DATE NOT NULL);

SELECT * FROM FactSalesOrder;
DELETE FROM FactSalesOrder;

-- Stored Procedure
CREATE OR ALTER PROCEDURE summary_order_status
	@StatusID INT AS 
BEGIN
	SELECT FactSalesOrder.OrderID, DimCustomer.CustomerName, DimProduct.ProductName, 
	FactSalesOrder.Quantity, DimStatusOrder.StatusOrder 
	FROM FactSalesOrder
	JOIN DimCustomer ON FactSalesOrder.CustomerID = DimCustomer.CustomerID
	JOIN DimProduct ON FactSalesOrder.ProductID = DimProduct.ProductID
	JOIN DimStatusOrder ON FactSalesOrder.StatusID = DimStatusOrder.StatusID
	WHERE FactSalesOrder.StatusID = @StatusID;
END;

EXEC summary_order_status @StatusID = 4;
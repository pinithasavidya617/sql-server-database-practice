CREATE DATABASE RetailStoreDB;
GO

USE RetailStoreDB;
GO

CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    OpenDate DATE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    BranchID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

INSERT INTO Branches VALUES
(1, 'Colombo Central', 'Colombo', '2018-05-10'),
(2, 'Kandy City', 'Kandy', '2019-08-15'),
(3, 'Galle Branch', 'Galle', '2021-02-01');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 250000, 20),
(102, 'Smartphone', 'Electronics', 120000, 50),
(103, 'Office Chair', 'Furniture', 35000, 40),
(104, 'Desk Table', 'Furniture', 55000, 25),
(105, 'Headphones', 'Electronics', 15000, 100);

INSERT INTO Sales VALUES
(1001, 101, 1, 2, '2024-01-10'),
(1002, 102, 1, 5, '2024-01-11'),
(1003, 103, 2, 3, '2024-01-12'),
(1004, 104, 3, 1, '2024-01-15'),
(1005, 105, 2, 10, '2024-01-20'),
(1006, 101, 3, 1, '2024-01-22');

--- UPDATE ---
UPDATE Products 
SET Price = Price * 1.10
WHERE ProductID = 101;

SELECT * FROM Products;

UPDATE Products
SET Price = Price * 1.05
WHERE Category = 'Electronics';

SELECT * FROM Products;

UPDATE Products
SET Stock = Stock + 25
WHERE ProductName = 'Headphones';

SELECT * FROM Products;

--- DELETE ----
DELETE FROM Sales
WHERE SaleID = '1006';

DELETE FROM Sales
WHERE ProductID IN (
    SELECT ProductID
    FROM Products
    WHERE Stock < 30
);

DELETE FROM Products
WHERE Stock < 30;

--- ALTER ---

ALTER TABLE Branches
ADD Email VARCHAR(150);

SELECT * FROM Branches;

--- ORDER BY ---
SELECT * FROM Products ORDER BY Price DESC, ProductName ASC;

SELECT * FROM Products ORDER BY Category ASC, Price ASC, Stock DESC;

--- LIKE ---

SELECT * FROM Products WHERE ProductName LIKE 'S%';

--- GROUP BY ---

SELECT Category, COUNT(*) AS  TotalProducts FROM Products GROUP BY Category;

SELECT BranchID, SUM(Quantity) as TotalQuantity FROM Sales GROUP BY BranchID;

--- JOINS ---

SELECT p.ProductName, b.BranchName, s.Quantity, s.SaleDate 
FROM  Sales s INNER JOIN Products p ON s.ProductID = p.ProductID
INNER JOIN Branches b ON s.BranchID = b.BranchID;

SELECT b.BranchName, COUNT(s.SaleID) AS TotalSales
FROM Branches b INNER JOIN Sales s
ON b.BranchID = s.BranchID GROUP BY b.BranchName;

SELECT b.BranchName, COUNT(s.SaleID) AS TotalSales
FROM Branches b LEFT JOIN Sales s
ON b.BranchID = s.BranchID GROUP BY b.BranchName;

SELECT p.ProductName, p.Category, SUM(s.Quantity) AS TotalQuantity
FROM Products p INNER JOIN Sales s
ON p.ProductID = s.ProductID GROUP BY p.ProductName, p.Category;

SELECT b.BranchName, p.ProductName, SUM(s.Quantity) AS TotalQuantity
FROM Sales s INNER JOIN Branches b ON s.BranchID = b.BranchID
INNER JOIN Products p ON p.ProductID = s.ProductID
GROUP BY b.BranchName, p.ProductName;

--- VIEWS ---
GO

CREATE OR ALTER VIEW ElectronicProducts AS
SELECT  ProductID, ProductName, Price FROM Products
WHERE Category = 'Electronics';

GO
CREATE OR ALTER VIEW BranchSalesSummaryView AS
SELECT b.BranchName, SUM(s.SaleID) AS TotalSalesCount, SUM(s.Quantity) AS TotalQuantityCount
FROM Branches b INNER JOIN Sales s
ON b.BranchID = s.BranchID GROUP BY b.BranchName;
GO

GO
CREATE OR ALTER VIEW ProductBranchSalesView AS
SELECT b.BranchName, p.ProductName, p.Category, SUM(s.Quantity) AS TotalQuantity
FROM Sales s INNER JOIN Branches b ON s.BranchID = b.BranchID
INNER JOIN Products p ON s.ProductID = p.ProductID
GROUP BY b.BranchName, p.ProductName, p.Category;
GO

--- STORED PROCEDURE ---

USE RetailStoreDB;
GO
CREATE OR ALTER PROCEDURE dbo.GetAllPRoducts 
AS
BEGIN
    SELECT * FROM Products
END;
GO

EXEC dbo.GetAllPRoducts;



GO
CREATE OR ALTER PROCEDURE dbo.GetProductsByCategory
    @Category VARCHAR(50)
AS
BEGIN
    SELECT ProductID, ProductName, Price, Stock
    FROM Products
    WHERE Category = @Category
END;
GO

EXEC dbo.GetProductsByCategory 'Electronics';



GO
CREATE OR ALTER PROCEDURE dbo.GetProductsByPriceRange
    @MinPrice DECIMAL(10, 2),
    @MaxPrice DECIMAL(10, 2)
AS
BEGIN
    SELECT ProductID, ProductName, Category, Price
    FROM Products
    WHERE Price BETWEEN @MinPrice AND @MaxPrice
END;
GO

EXEC dbo.GetProductsByPriceRange 10000, 20000;


GO
CREATE OR ALTER PROCEDURE dbo.IncreaseProductPrice 
    @ProductID INT,
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Products
    SET Price = Price + (Price * @IncreasePercentage/100)
    WHERE ProductID = @ProductID
END;
GO

EXEC dbo.IncreaseProductPrice 101, 10;



GO
CREATE OR ALTER PROCEDURE dbo.AddNewProduct
    @ProductID INT,
    @ProductName VARCHAR(100),
    @Category VARCHAR(50),
    @Price DECIMAL(10, 2),
    @Stock INT
AS
BEGIN
    INSERT INTO Products VALUES(
        @ProductID, @ProductName, @Category, @Price, @Stock
    )
END;
GO

EXEC dbo.AddNewProduct
    106,
    'Gaming Mouse',
    'Electronics',
    18000,
    60;

SELECT * FROM Products WHERE ProductID = 106;



GO
CREATE OR ALTER PROCEDURE dbo.GetTotalSalesQuantityByBranch
    @BranchID INT,
    @TotalQuantity INT OUTPUT
AS
BEGIN
    SELECT @TotalQuantity = ISNULL(SUM(Quantity), 0)
    FROM Sales
    WHERE BranchID = @BranchID
END;
GO


DECLARE @Total INT;

EXEC dbo.GetTotalSalesQuantityByBranch 
    @BranchID = 1,
    @TotalQuantity = @Total OUTPUT;

SELECT @Total AS TotalSold;
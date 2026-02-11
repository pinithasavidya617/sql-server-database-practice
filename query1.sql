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
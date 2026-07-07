USE MyDBProject;

-- Xóa bảng nếu đã tồn tại (Xóa theo thứ tự phụ thuộc khóa ngoại trước)
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 1. Bảng Khách hàng (Customers)
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    JoinDate DATE
);

-- 2. Bảng Sản phẩm (Products)
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- 3. Bảng Đơn hàng (Orders)
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(20) DEFAULT 'Shipped',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 4. Bảng Chi tiết đơn hàng (OrderDetails)
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ==========================================
-- CHÈN DỮ LIỆU MẪU (10 Khách hàng, 5 Sản phẩm, 10 Đơn hàng, 12 Chi tiết đơn)
-- ==========================================

-- Chèn dữ liệu Customers
INSERT INTO Customers (CustomerName, Email, Gender, Age, City, JoinDate) VALUES
('An Nguyen', 'an.nguyen@email.com', 'Female', 25, 'Hanoi', '2026-01-15'),
('Binh Tran', 'binh.tran@email.com', 'Male', 34, 'HCM', '2026-02-10'),
('Cuong Le', 'cuong.le@email.com', 'Male', 19, 'Da Nang', '2026-03-01'),
('Dung Pham', 'dung.pham@email.com', 'Male', 45, 'Hanoi', '2026-03-12'),
('Em My', 'em.my@email.com', 'Female', 28, 'HCM', '2026-04-05'),
('Giang Hoang', 'giang.hoang@email.com', 'Male', 22, 'Da Nang', '2026-04-18'),
('Hoa Vu', 'hoa.vu@email.com', 'Female', 31, 'Hanoi', '2026-05-02'),
('Hai Do', 'hai.do@email.com', 'Male', 27, 'Can Tho', '2026-05-20'),
('Huong Le', 'huong.le@email.com', 'Female', 24, 'HCM', '2026-06-01'),
('Khanh Trinh', 'khanh.trinh@email.com', 'Male', 40, 'Hai Phong', '2026-06-15');

-- Chèn dữ liệu Products
INSERT INTO Products (ProductName, Category, Price, Stock) VALUES
('iPhone 15', 'Electronics', 1000.00, 50),
('Macbook Pro', 'Electronics', 2000.00, 30),
('Nike Air Max', 'Shoes', 120.00, 100),
('Adidas Ultraboost', 'Shoes', 180.00, 80),
('Leather Wallet', 'Accessories', 50.00, 200);

-- Chèn dữ liệu Orders
INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES
(1, '2026-02-20', 'Shipped'),
(2, '2026-02-22', 'Shipped'),
(1, '2026-03-05', 'Shipped'),
(3, '2026-03-10', 'Shipped'),
(5, '2026-04-15', 'Shipped'),
(2, '2026-04-20', 'Pending'),
(4, '2026-05-01', 'Cancelled'),
(7, '2026-05-10', 'Shipped'),
(9, '2026-06-05', 'Shipped'),
(8, '2026-06-20', 'Pending');

-- Chèn dữ liệu OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1000.00), -- Đơn 1 mua 1 iPhone 15
(1, 3, 2, 120.00),  -- Đơn 1 mua 2 Nike Air Max
(2, 2, 1, 2000.00), -- Đơn 2 mua 1 Macbook
(3, 5, 1, 50.00),   -- Đơn 3 mua 1 Leather Wallet
(4, 3, 1, 120.00),  -- Đơn 4 mua 1 Nike Air Max
(5, 4, 1, 180.00),  -- Đơn 5 mua 1 Adidas
(5, 5, 2, 50.00),   -- Đơn 5 mua 2 Leather Wallet
(6, 1, 1, 1000.00), -- Đơn 6 mua 1 iPhone 15
(7, 2, 1, 2000.00), -- Đơn 7 mua 1 Macbook
(8, 3, 1, 120.00),  -- Đơn 8 mua 1 Nike Air Max
(9, 1, 1, 1000.00), -- Đơn 9 mua 1 iPhone 15
(10, 5, 3, 50.00);  -- Đơn 10 mua 3 Leather Wallet

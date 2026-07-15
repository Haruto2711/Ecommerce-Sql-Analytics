-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 05_sales_performance_deepdive.sql
-- CHẶNG 4: TRUY VẤN NÂNG CAO (SUBQUERY & CTE)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b task/GSHOP-500-sales-deepdive
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #501] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để phục vụ rà soát danh mục hàng hóa, em hãy trích xuất danh sách 
--  các sản phẩm trong bảng Products có giá bán (Price) cao hơn giá bán trung bình 
--  của toàn bộ các sản phẩm có trong hệ thống nhé.
--  Danh sách cần hiển thị: Mã sản phẩm (ProductID), Tên sản phẩm (ProductName), và Giá bán (Price)."
--  Gợi ý: Sử dụng một truy vấn con (Subquery) ở mệnh đề WHERE để tính giá trung bình:
--        WHERE Price > (SELECT AVG(Price) FROM Products)
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select ProductID, ProductName, Price
from products 
where price > (select avg(price) from products);



-- --------------------------------------------------------------------
-- [TICKET #502] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn gửi khảo sát riêng cho nhóm khách hàng đã từng đặt hàng tại hệ thống 
--  nhưng chưa bao giờ mua sản phẩm Macbook Pro (có ProductID = 2). 
--  Bạn hãy trích xuất danh sách gồm: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), và Email."
--  Gợi ý:
--  1. Sử dụng WHERE CustomerID IN (SELECT CustomerID FROM Orders) để lọc các khách hàng đã từng mua hàng.
--  2. Sử dụng AND CustomerID NOT IN (SELECT o.CustomerID FROM Orders o INNER JOIN OrderDetails od ON o.OrderID = od.OrderID WHERE od.ProductID = 2) để loại trừ những khách đã từng mua sản phẩm ID = 2.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select CustomerID, CustomerName,Email
from customers
where CustomerID IN (Select CustomerID from Orders) and 
CustomerID NOT IN (SELECT o.CustomerID from Orders o inner join 
orderdetails od on o.OrderID = od.OrderID
where od.ProductID = 2);




-- --------------------------------------------------------------------
-- [TICKET #503] (Yêu cầu từ Bộ phận Tài chính - Finance Team)
-- "Chào bạn, bộ phận tài chính cần tổng hợp tổng số tiền chi trả thực tế của từng khách hàng 
--  (không tính doanh thu từ các đơn hàng bị Hủy 'Cancelled').
--  Để câu lệnh gọn gàng và dễ bảo trì, bạn hãy sử dụng bảng tạm (CTE - WITH...) 
--  để tính tổng tiền chi tiêu theo từng khách hàng từ trước, sau đó kết hợp với bảng Customers 
--  để hiển thị báo cáo gồm: CustomerID, CustomerName, và TotalSpent (Sử dụng COALESCE để hiển thị 0 cho người chưa mua gì).
--  Sắp xếp danh sách theo tổng số tiền giảm dần (DESC)."
--  Gợi ý:
--  1. Định nghĩa CTE (bảng tạm) tính tổng chi tiêu:
--     WITH CustomerSpending AS (
--         SELECT o.CustomerID, SUM(od.Quantity * od.UnitPrice) AS TotalAmount
--         FROM Orders o
--         INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--         WHERE o.Status <> 'Cancelled'
--         GROUP BY o.CustomerID
--     )
--  2. Truy vấn chính: LEFT JOIN từ Customers sang bảng tạm CustomerSpending qua CustomerID.
--  3. Sử dụng COALESCE(cs.TotalAmount, 0) và ORDER BY.
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH CustomerSpending AS (
    SELECT o.CustomerID, SUM(od.Quantity * od.UnitPrice) AS TotalAmount
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.Status <> 'Cancelled'
    GROUP BY o.CustomerID
)
SELECT c.CustomerID, c.CustomerName, COALESCE(cs.TotalAmount, 0) AS TotalSpent
FROM Customers c
LEFT JOIN CustomerSpending cs ON c.CustomerID = cs.CustomerID
ORDER BY TotalSpent DESC;



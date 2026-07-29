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




-- --------------------------------------------------------------------
-- [TICKET #504] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào bạn, hãy tìm tất cả các khách hàng đã từng đặt ít nhất một mặt hàng 
--  có giá trị dòng sản phẩm đơn lẻ (Thành tiền của dòng đó) lớn hơn giá trị dòng sản phẩm 
--  trung bình của toàn bộ hệ thống nhé.
--  Hiển thị thông tin: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), và Email."
--  Gợi ý:
--  1. Sử dụng truy vấn con tính giá trị dòng trung bình: SELECT AVG(Quantity * UnitPrice) FROM OrderDetails.
--  2. Sử dụng truy vấn con thứ hai để tìm CustomerID từ các đơn hàng có dòng sản phẩm vượt giá trị trung bình trên.
--  3. Sử dụng WHERE CustomerID IN (...) ở truy vấn chính.
-- --------------------------------------------------------------------

-- SQL query của bạn:
SELECT CustomerID, CustomerName, Email
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE od.Quantity * od.UnitPrice > (
        SELECT AVG(Quantity * UnitPrice) FROM OrderDetails
    )
);



-- --------------------------------------------------------------------
-- [TICKET #505] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn lọc ra các sản phẩm thuộc danh mục Thời trang ('Clothes' hoặc 'Shoes') 
--  nhưng chưa từng được mua bởi bất kỳ khách hàng nào sống tại thành phố Hà Nội (Hanoi). 
--  Hãy hiển thị: Mã sản phẩm (ProductID), Tên sản phẩm (ProductName), Danh mục (Category), và Giá bán (Price)."
--  Gợi ý:
--  1. Sử dụng WHERE Category IN ('Clothes', 'Shoes') để lọc sản phẩm thời trang.
--  2. Sử dụng AND ProductID NOT IN (SELECT od.ProductID FROM OrderDetails od INNER JOIN Orders o ON od.OrderID = o.OrderID INNER JOIN Customers c ON o.CustomerID = c.CustomerID WHERE c.City = 'Hanoi') để loại trừ sản phẩm đã được mua bởi khách ở Hanoi.
-- --------------------------------------------------------------------

-- SQL query của bạn:
SELECT ProductID, ProductName, Category, Price
From products 
where Category IN ('Clothes', 'Shoes')
And ProductID NOT IN (
Select od.ProductID 
from OrderDetails od
inner join Orders o ON od.OrderID = o.OrderID 
INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE c.City = 'Hanoi');



-- --------------------------------------------------------------------
-- [TICKET #506] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, hãy lập báo cáo hiển thị tổng số lượng sản phẩm bán được (TotalSold) 
--  của từng Danh mục sản phẩm (Category) đối với các đơn hàng đã giao thành công (Status = 'Shipped'). 
--  Yêu cầu: Sử dụng CTE để tính tổng số lượng sản phẩm bán được theo từng ProductID trước, 
--  sau đó ở truy vấn chính, liên kết bảng Products với CTE này để gom nhóm theo Category và 
--  tính tổng số lượng bán được của danh mục đó. Sắp xếp kết quả theo tổng số lượng bán giảm dần (DESC)."
--  Gợi ý:
--  1. Định nghĩa CTE (ProductSales) tính tổng số lượng bán theo ProductID:
--     WITH ProductSales AS (
--         SELECT od.ProductID, SUM(od.Quantity) AS QuantitySold
--         FROM Orders o
--         INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--         WHERE o.Status = 'Shipped'
--         GROUP BY od.ProductID
--     )
--  2. Truy vấn chính: INNER JOIN từ Products sang CTE ProductSales qua ProductID.
--  3. Gom nhóm theo Category và tính SUM(ps.QuantitySold) làm TotalSold. Sắp xếp giảm dần.
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH ProductSales AS (
    SELECT od.ProductID, SUM(od.Quantity) AS QuantitySold
      FROM Orders o
      INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
      WHERE o.Status = 'Shipped'
       GROUP BY od.ProductID
     )
     Select p.Category, sum(ps.QuantitySold) as TotalSold
     from products p 
     inner join ProductSales ps
     on p.ProductID = ps.ProductID
     group by p.Category 
     order by TotalSold desc;




-- --------------------------------------------------------------------
-- [TICKET #507] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào bạn, hãy trích xuất danh sách các sản phẩm trong bảng Products có giá bán (Price) 
--  cao hơn giá bán trung bình của chính danh mục (Category) đó nhé.
--  Danh sách cần hiển thị: Mã sản phẩm (ProductID), Tên sản phẩm (ProductName), 
--  Danh mục (Category), và Giá bán (Price)."
--  Gợi ý: Sử dụng truy vấn con tương quan (Correlated Subquery) ở WHERE:
--        WHERE Price > (SELECT AVG(Price) FROM Products p2 WHERE p2.Category = p.Category)
-- --------------------------------------------------------------------

-- SQL query của bạn:

Select p.ProductID, p.ProductName,p.Category,p.Price
from products p
where price > (select avg(price) from products p2 where p2.Category = p.Category); 


-- --------------------------------------------------------------------
-- [TICKET #508] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn tìm các khách hàng ở HCM đã từng mua đơn hàng thành công (Shipped) 
--  nhưng chưa từng mua bất kỳ sản phẩm nào thuộc danh mục thời trang 'Clothes' hoặc 'Shoes'.
--  Báo cáo hiển thị: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), và Email."
--  Gợi ý:
--  1. Lọc City = 'HCM' ở WHERE.
--  2. Sử dụng CustomerID IN (SELECT CustomerID FROM Orders WHERE Status = 'Shipped') để lọc khách có đơn thành công.
--  3. Sử dụng CustomerID NOT IN (SELECT o.CustomerID FROM Orders o INNER JOIN OrderDetails od ON o.OrderID = od.OrderID INNER JOIN Products p ON od.ProductID = p.ProductID WHERE p.Category IN ('Clothes', 'Shoes')) để loại trừ nhóm khách hàng đã từng mua thời trang.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select CustomerID, CustomerName, Email
from customers 
Where City = 'HCM' 
  and CustomerID IN (Select CustomerID from Orders Where Status = 'Shipped') 
  and CustomerID NOT IN (
      Select o.CustomerID 
      from Orders o 
      inner join orderdetails od ON o.OrderID = od.OrderID 
      INNER JOIN Products p ON od.ProductID = p.ProductID 
      WHERE p.Category IN ('Clothes', 'Shoes')
  );




-- --------------------------------------------------------------------
-- [TICKET #509] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Hãy tính tổng doanh thu thực tế (CityRevenue) của từng thành phố đối với các đơn hàng Shipped 
--  và hiển thị thêm tổng doanh thu của toàn bộ hệ thống (TotalSystemRevenue) để tiện so sánh tỷ trọng.
--  Yêu cầu: Sử dụng CTE để tính tổng doanh thu từng thành phố trước, sau đó ở truy vấn chính, 
--  sử dụng một truy vấn con đơn trị để tính tổng doanh thu toàn hệ thống.
--  Báo cáo hiển thị: Thành phố (City), Doanh thu thành phố (CityRevenue), và Doanh thu toàn hệ thống (TotalSystemRevenue).
--  Sắp xếp danh sách theo doanh thu thành phố giảm dần (DESC)."
--  Gợi ý:
--  1. Định nghĩa CTE tính doanh thu từng thành phố:
--     WITH CityRevenueCTE AS (
--         SELECT c.City, SUM(od.Quantity * od.UnitPrice) AS CityRevenue
--         FROM Customers c
--         INNER JOIN Orders o ON c.CustomerID = o.CustomerID
--         INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--         WHERE o.Status = 'Shipped'
--         GROUP BY c.City
--     )
--  2. Truy vấn chính: SELECT City, CityRevenue, (SELECT SUM(od.Quantity * od.UnitPrice) FROM Orders o INNER JOIN OrderDetails od ON o.OrderID = od.OrderID WHERE o.Status = 'Shipped') AS TotalSystemRevenue FROM CityRevenueCTE.
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH CityRevenueCTE AS (
    SELECT c.City, SUM(od.Quantity * od.UnitPrice) AS CityRevenue
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.Status = 'Shipped'
    GROUP BY c.City
)
SELECT City, CityRevenue,
       (
           SELECT SUM(od.Quantity * od.UnitPrice) 
           FROM Orders o 
           INNER JOIN OrderDetails od ON o.OrderID = od.OrderID 
           WHERE o.Status = 'Shipped'
       ) AS TotalSystemRevenue 
FROM CityRevenueCTE
ORDER BY CityRevenue DESC;




-- --------------------------------------------------------------------
-- [TICKET #510] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, để đánh giá mức giá các sản phẩm đang hiển thị trên web, em hãy trích xuất 
--  danh sách các sản phẩm có giá bán (Price) cao hơn giá bán trung bình thực tế của toàn bộ các sản phẩm 
--  được mua trong các đơn hàng đã giao thành công (Status = 'Shipped').
--  Hiển thị thông tin: Mã sản phẩm (ProductID), Tên sản phẩm (ProductName), và Giá bán (Price)."
--  Gợi ý: Sử dụng truy vấn con tính giá bán trung bình thực tế:
--        SELECT AVG(od.UnitPrice) FROM OrderDetails od INNER JOIN Orders o ON od.OrderID = o.OrderID WHERE o.Status = 'Shipped'
--        Và dùng WHERE Price > (...) ở truy vấn chính.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select ProductID, ProductName, Price
from products
where Price > (
    select avg(od.UnitPrice) 
    from orderdetails od 
    inner join orders o ON od.OrderID = o.OrderID
    where o.Status = 'Shipped'
);



-- --------------------------------------------------------------------
-- [TICKET #511] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn lọc ra các khách hàng VIP sống tại thành phố HCM để gửi voucher tri ân. 
--  Hãy tìm các khách hàng ở HCM đã từng đặt ít nhất một đơn hàng có tổng giá trị đơn hàng 
--  (Thành tiền đơn đặt hàng đó) lớn hơn giá trị trung bình của toàn bộ các đơn hàng Shipped trong hệ thống.
--  Báo cáo hiển thị: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), và Email."
--  Gợi ý:
--  1. Lọc City = 'HCM' ở WHERE.
--  2. Sử dụng CustomerID IN để lọc:
--     - Truy vấn con tính tổng tiền từng đơn hàng: SUM(od.Quantity * od.UnitPrice) GROUP BY o.OrderID.
--     - Dùng HAVING để so sánh tổng này với một truy vấn con tính giá trị trung bình của toàn bộ đơn Shipped.
--     - Giá trị đơn hàng trung bình tính bằng: SELECT AVG(OrderTotal) FROM (SELECT SUM(od2.Quantity * od2.UnitPrice) AS OrderTotal FROM Orders o2 INNER JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID WHERE o2.Status = 'Shipped' GROUP BY o2.OrderID) AS SubQuery.
-- --------------------------------------------------------------------

-- SQL query của bạn:
SELECT CustomerID, CustomerName, Email
FROM Customers
WHERE City = 'HCM'
  AND CustomerID IN (
      SELECT o.CustomerID
      FROM Orders o
      INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
      GROUP BY o.OrderID, o.CustomerID
      HAVING SUM(od.Quantity * od.UnitPrice) > (
          SELECT AVG(OrderTotal)
          FROM (
              SELECT SUM(od2.Quantity * od2.UnitPrice) AS OrderTotal
              FROM Orders o2
              INNER JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID
              WHERE o2.Status = 'Shipped'
              GROUP BY o2.OrderID
          ) AS SubQuery
      )
  );



-- --------------------------------------------------------------------
-- [TICKET #512] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để phục vụ báo cáo hiệu suất của sản phẩm, hãy lập danh sách hiển thị tên sản phẩm (ProductName), 
--  danh mục sản phẩm (Category), và tỷ lệ phần trăm đóng góp doanh thu (RevenueContributionPercent) 
--  của sản phẩm đó so với tổng doanh thu của toàn bộ danh mục sản phẩm của nó (chỉ tính đơn hàng Shipped).
--  Yêu cầu: 
--  1. Định nghĩa CTE thứ nhất (ProductRevenueCTE) để tính tổng doanh thu của từng sản phẩm.
--  2. Định nghĩa CTE thứ hai (CategoryRevenueCTE) để tính tổng doanh thu của từng danh mục.
--  3. Ở truy vấn chính: JOIN hai CTE trên qua danh mục sản phẩm (Category), thực hiện tính tỷ lệ phần trăm:
--     ROUND((ProductRevenue / CategoryRevenue) * 100, 2) AS RevenueContributionPercent
--  4. Sắp xếp kết quả theo danh mục sản phẩm tăng dần (ASC) và tỷ lệ phần trăm giảm dần (DESC)."
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH ProductRevenueCTE AS (
    SELECT p.ProductID, p.ProductName, p.Category, SUM(od.Quantity * od.UnitPrice) AS ProductRevenue
    FROM Products p
    INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.Status = 'Shipped'
    GROUP BY p.ProductID, p.ProductName, p.Category
),
CategoryRevenueCTE AS (
    SELECT p2.Category, SUM(od2.Quantity * od2.UnitPrice) AS CategoryRevenue
    FROM Products p2
    INNER JOIN OrderDetails od2 ON p2.ProductID = od2.ProductID
    INNER JOIN Orders o2 ON od2.OrderID = o2.OrderID
    WHERE o2.Status = 'Shipped'
    GROUP BY p2.Category
)
SELECT pr.ProductName, pr.Category,
       ROUND((pr.ProductRevenue / cr.CategoryRevenue) * 100, 2) AS RevenueContributionPercent
FROM ProductRevenueCTE pr
INNER JOIN CategoryRevenueCTE cr ON pr.Category = cr.Category
ORDER BY pr.Category ASC, RevenueContributionPercent DESC;




-- --------------------------------------------------------------------
-- [TICKET #513] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, hãy tìm tất cả các khách hàng sống tại thành phố Hà Nội (Hanoi) 
--  có tổng chi tiêu thực tế (TotalSpent) lớn hơn mức chi tiêu trung bình của các khách hàng sống tại Đà Nẵng (Da Nang).
--  Chỉ tính doanh số từ các đơn hàng giao thành công (Status = 'Shipped').
--  Hiển thị thông tin: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), và Tổng chi tiêu (TotalSpent).
--  Sắp xếp tổng tiền chi tiêu giảm dần (DESC)."
--  Gợi ý:
--  1. Định nghĩa một CTE tính tổng chi tiêu thực tế của từng khách hàng kèm theo thành phố của họ (Gom nhóm theo khách hàng và thành phố).
--  2. Ở truy vấn chính: Lọc thành phố là 'Hanoi' và dùng truy vấn con ở WHERE để tính chi tiêu trung bình của khách hàng ở 'Da Nang' từ chính CTE đó.
-- --------------------------------------------------------------------

-- SQL query của bạn:
With CustomerSpending AS (
    Select c.CustomerID, c.CustomerName,c.City,
    sum(od.Quantity * od.UnitPrice) as 'Total_Spent'
    from customers c
    inner join orders o
    on c.CustomerID = o.CustomerID
    inner join orderdetails od
    on o.OrderID = od.OrderID
    WHERE o.Status = 'Shipped'
    GROUP BY c.CustomerID, c.CustomerName, c.City
)
Select CustomerID,CustomerName, Total_Spent
From CustomerSpending
Where City = 'Hanoi'
And Total_Spent > (Select Avg(Total_Spent) 
From CustomerSpending 
Where City = 'Da Nang'
)
Order by Total_Spent desc;



-- --------------------------------------------------------------------
-- [TICKET #514] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn thiết kế quà tặng kèm công nghệ cho khách hàng. Hãy tìm tất cả các sản phẩm 
--  thuộc danh mục Công nghệ/Điện tử (Category = 'Electronics') có tổng số lượng bán ra (TotalQuantitySold) 
--  lớn hơn số lượng bán ra trung bình của tất cả các sản phẩm trong danh mục Thời trang ('Clothes' hoặc 'Shoes').
--  Chỉ tính các đơn hàng giao thành công (Status = 'Shipped').
--  Hiển thị thông tin: Mã sản phẩm (ProductID), Tên sản phẩm (ProductName), và Tổng số lượng bán ra.
--  Sắp xếp số lượng bán ra giảm dần (DESC)."
--  Gợi ý:
--  1. Dùng CTE để tính tổng lượng bán ra thực tế của từng sản phẩm kèm danh mục của sản phẩm đó.
--  2. Ở truy vấn chính: Chọn các sản phẩm thuộc danh mục 'Electronics' có số lượng bán lớn hơn trung bình số lượng bán của các sản phẩm danh mục 'Clothes', 'Shoes' (sử dụng truy vấn con từ chính CTE trên).
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH ProductSales AS (
    SELECT p.ProductID, p.ProductName, p.Category, COALESCE(SUM(od.Quantity), 0) AS TotalQuantitySold
    FROM Products p
    LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
    LEFT JOIN Orders o ON od.OrderID = o.OrderID AND o.Status = 'Shipped'
    GROUP BY p.ProductID, p.ProductName, p.Category
)
SELECT ProductID, ProductName, TotalQuantitySold
FROM ProductSales
WHERE Category = 'Electronics'
  AND TotalQuantitySold > (
      SELECT AVG(TotalQuantitySold)
      FROM ProductSales
      WHERE Category IN ('Clothes', 'Shoes')
  )
ORDER BY TotalQuantitySold DESC;



-- --------------------------------------------------------------------
-- [TICKET #515] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn kiểm tra các đơn hàng có nhiều mặt hàng hơn bình thường để tối ưu hóa nhân sự đóng gói. 
--  Hãy tìm các đơn hàng có số lượng dòng sản phẩm khác nhau (UniqueProductsCount) 
--  lớn hơn số lượng dòng sản phẩm khác nhau trung bình của toàn bộ các đơn hàng trong hệ thống.
--  Hiển thị thông tin: Mã đơn hàng (OrderID), Tên khách hàng (CustomerName), và Số lượng dòng sản phẩm khác nhau (UniqueProductsCount).
--  Sắp xếp theo số lượng dòng giảm dần (DESC)."
--  Gợi ý:
--  1. Dùng CTE (OrderItemCount) để tính số lượng mặt hàng khác nhau trong từng đơn hàng (Gom nhóm theo OrderID, CustomerID và COUNT(DISTINCT ProductID)).
--  2. Ở truy vấn chính: INNER JOIN CTE này với bảng Customers để lấy tên khách hàng.
--  3. Dùng WHERE để lọc số lượng mặt hàng lớn hơn giá trị trung bình (tính bằng truy vấn con AVG từ chính CTE).
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH OrderItemCount AS (
    SELECT o.OrderID, o.CustomerID, COUNT(DISTINCT od.ProductID) AS UniqueProductsCount
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.CustomerID
)
SELECT oic.OrderID, c.CustomerName, oic.UniqueProductsCount
FROM OrderItemCount oic
INNER JOIN Customers c ON oic.CustomerID = c.CustomerID
WHERE oic.UniqueProductsCount > (
    SELECT AVG(UniqueProductsCount)
    FROM OrderItemCount
)
ORDER BY oic.UniqueProductsCount DESC;











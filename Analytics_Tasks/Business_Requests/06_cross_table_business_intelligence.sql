-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 06_cross_table_business_intelligence.sql
-- BÀI TẬP TỔNG HỢP: KẾT HỢP CHẶNG 1, 2 VÀ 3 (FILTER, AGGREGATE & JOIN)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b task/GSHOP-600-integrated-reporting
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #601] (Yêu cầu từ Phòng Marketing - Marketing Lead)
-- "Chào em, để chuẩn bị chiến dịch quảng cáo tập trung tại miền Nam, em hãy thống kê 
--  tổng số lượng sản phẩm Thời trang (danh mục 'Clothes' hoặc 'Shoes') đã bán được 
--  cho các khách hàng sống tại TP. Hồ Chí Minh (City = 'HCM'). 
--  Yêu cầu hiển thị báo cáo gồm: 
--  Tên sản phẩm (ProductName), Danh mục sản phẩm (Category), và Tổng số lượng đã bán (đặt tên là TotalSold).
--  Lưu ý: Chỉ hiển thị các sản phẩm có tổng số lượng bán được từ 2 cái trở lên (>= 2), 
--  đồng thời sắp xếp danh sách theo số lượng bán được giảm dần (DESC)."
--  Gợi ý: 
--  1. Ghép 4 bảng Customers, Orders, OrderDetails, và Products.
--  2. Lọc dữ liệu thô ở WHERE: Danh mục thuộc 'Clothes', 'Shoes' VÀ Thành phố là 'HCM'.
--  3. Gom nhóm GROUP BY theo sản phẩm và tính SUM(od.Quantity).
--  4. Lọc nhóm ở HAVING: Tổng số lượng bán được >= 2.
--  5. Sắp xếp kết quả ở ORDER BY.
-- --------------------------------------------------------------------

-- SQL query của bạn:

SELECT p.ProductName, p.Category, SUM(od.Quantity) AS TotalSold
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category IN ('Clothes', 'Shoes') AND c.City = 'HCM'
GROUP BY p.ProductID, p.ProductName, p.Category
HAVING TotalSold >= 2
ORDER BY TotalSold DESC;



-- --------------------------------------------------------------------
-- [TICKET #602] (Yêu cầu từ Bộ phận Tài chính - Finance Team)
-- "Chúng tôi muốn rà soát các đơn đặt hàng có giá trị lớn từ các khách hàng lớn tuổi. 
--  Hãy thống kê tổng số tiền chi trả thực tế (đặt tên là TotalSpent) của từng đơn hàng (OrderID) 
--  thỏa mãn đồng thời các điều kiện sau:
--  1. Trạng thái đơn hàng là Đã giao hàng (Status = 'Shipped').
--  2. Khách hàng đặt đơn hàng đó phải trên 30 tuổi (Age > 30).
--  3. Chỉ hiển thị các đơn hàng có tổng số tiền từ 1000 USD trở lên (>= 1000).
--  Hiển thị các thông tin: OrderID, Tên khách hàng (CustomerName), Ngày đặt hàng (OrderDate), 
--  và Tổng số tiền (TotalSpent). Sắp xếp theo ngày đặt hàng giảm dần (DESC)."
--  Gợi ý: 
--  1. Ghép 3 bảng Customers, Orders, và OrderDetails.
--  2. Lọc dữ liệu thô ở WHERE: Status là 'Shipped' VÀ Age > 30.
--  3. Gom nhóm GROUP BY theo đơn hàng và tính tổng tiền: SUM(od.Quantity * od.UnitPrice).
--  4. Lọc nhóm ở HAVING: Tổng số tiền >= 1000.
--  5. Sắp xếp kết quả ở ORDER BY.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select o.OrderID, c.CustomerName, o.OrderDate, sum(od.Quantity * od.UnitPrice) as TotalSpent
from customers c
inner join orders o
on c.CustomerID = o.CustomerID
inner join orderdetails od
on o.OrderID = od.OrderID
where o.Status = 'Shipped' and c.age > 30
group by o.OrderID,c.CustomerName,o.OrderDate
having TotalSpent >= 1000
order by o.OrderDate desc;



-- --------------------------------------------------------------------
-- [TICKET #603] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào team Data, nhờ bạn thống kê số lượng đơn hàng của nhóm khách hàng mới đăng ký 
--  trong năm 2026 (ngày gia nhập JoinDate >= '2026-01-01').
--  Yêu cầu hiển thị: Mã khách hàng (CustomerID), Tên khách hàng (CustomerName), 
--  Ngày gia nhập (JoinDate), và Tổng số đơn hàng đã đặt (đặt tên là TotalOrders - không tính các đơn hàng bị Hủy 'Cancelled').
--  Lưu ý: Phải hiển thị đầy đủ tất cả khách hàng mới gia nhập năm 2026, kể cả những người 
--  chưa từng mua bất kỳ đơn hàng nào (với số lượng đơn hàng hiển thị là 0). 
--  Sắp xếp danh sách theo ngày gia nhập tăng dần (ASC)."
--  Gợi ý: 
--  1. Sử dụng LEFT JOIN từ Customers sang Orders qua CustomerID.
--  2. Điều kiện loại trừ đơn hàng bị hủy đặt ở mệnh đề ON của phép JOIN để giữ lại khách hàng chưa mua hàng:
--     left join Orders o on c.CustomerID = o.CustomerID and o.Status <> 'Cancelled'
--  3. Lọc dữ liệu ở WHERE: c.JoinDate >= '2026-01-01'.
--  4. Gom nhóm GROUP BY theo khách hàng.
--  5. Tính tổng số đơn bằng cách đếm COUNT(o.OrderID), kết hợp COALESCE(COUNT(o.OrderID), 0) để hiển thị số 0.
--  6. Sắp xếp ở ORDER BY.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select c.CustomerID,c.CustomerName, c.JoinDate, COALESCE(COUNT(o.OrderID), 0) as TotalOrders
from customers c
left join orders o
on c.CustomerID = o.CustomerID and o.Status <> 'Cancelled'
where c.JoinDate >= '2026-01-01'
group by c.CustomerID,c.CustomerName,c.JoinDate
order by c.JoinDate asc;




-- --------------------------------------------------------------------
-- [TICKET #604] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào bạn, hãy thống kê tổng doanh thu thực tế (TotalRevenue) của mỗi danh mục sản phẩm 
--  (Category) bán ra cho các khách hàng sống tại thành phố HCM hoặc Đà Nẵng (Da Nang). 
--  Lưu ý: Chỉ tính các đơn hàng đã được giao thành công (Status = 'Shipped') và chỉ hiển thị 
--  các danh mục sản phẩm đem lại tổng doanh số từ 500 USD trở lên."
--  Gợi ý: Ghép 4 bảng Products, OrderDetails, Orders, và Customers. 
--        Lọc City IN ('HCM', 'Da Nang') VÀ Status = 'Shipped' ở WHERE.
--        Gom nhóm theo Category và tính SUM(od.Quantity * od.UnitPrice).
--        Lọc nhóm ở HAVING: Tổng doanh thu >= 500.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select p.Category, sum(od.Quantity * od.UnitPrice) as TotalRevenue
from products p
inner join orderdetails od
on p.ProductID = od.ProductID
inner join orders o
on od.OrderID = o.OrderID
inner join Customers c
on o.CustomerID = c.CustomerID
where city in ('HCM', 'Da Nang') and status = 'Shipped'
group by p.Category
Having TotalRevenue >= 500;



-- --------------------------------------------------------------------
-- [TICKET #605] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn đánh giá thói quen mua sắm của nhóm khách hàng trẻ tuổi tại Hà Nội. 
--  Hãy tính tổng số lượng sản phẩm đã mua (TotalQuantitySold) của từng khách hàng sống tại Hanoi 
--  và có độ tuổi từ 30 trở xuống (Age <= 30).
--  Lưu ý: Phải hiển thị đầy đủ tất cả khách hàng thỏa mãn điều kiện trên, kể cả những người 
--  chưa từng mua bất kỳ đơn hàng nào (với số lượng sản phẩm hiển thị là 0). 
--  Hiển thị các thông tin: Tên khách hàng (CustomerName), Email, Độ tuổi (Age), và Tổng số lượng đã mua. 
--  Sắp xếp danh sách theo độ tuổi tăng dần (ASC)."
--  Gợi ý: Dùng LEFT JOIN từ Customers sang Orders, ghép tiếp sang OrderDetails qua LEFT JOIN. 
--        Lọc City = 'Hanoi' VÀ Age <= 30 ở WHERE. Gom nhóm theo khách hàng và 
--        tính COALESCE(SUM(od.Quantity), 0).
-- --------------------------------------------------------------------

-- SQL query của bạn:
select c.CustomerName,c.Email,c.Age,coalesce(sum(od.Quantity),0) as TotalQuantitySold
from Customers c
left join orders o
on c.CustomerID = o.CustomerID
left join orderdetails od
on o.OrderID = od.OrderID
Where c.City = 'Hanoi' and c.Age <= 30
group by c.CustomerID, c.CustomerName, c.Email, c.Age
order by c.Age asc;



-- --------------------------------------------------------------------
-- [TICKET #606] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào team Data, để đo lường tốc độ giao hàng, bạn hãy liệt kê các đơn hàng giao thành công 
--  (Status = 'Shipped') được đặt từ ngày 01/01/2026 trở đi (OrderDate >= '2026-01-01').
--  Yêu cầu hiển thị: Mã đơn hàng (OrderID), Ngày đặt hàng (OrderDate), Ngày khách hàng gia nhập (JoinDate), 
--  Tên khách hàng (CustomerName), và Số ngày chênh lệch từ ngày khách gia nhập đến ngày đặt hàng 
--  (đặt tên cột là DaysFromJoinToOrder). 
--  Sắp xếp danh sách theo số ngày chênh lệch giảm dần (DESC)."
--  Gợi ý: Ghép Orders và Customers qua CustomerID. Lọc Status = 'Shipped' VÀ OrderDate >= '2026-01-01' ở WHERE. 
--        Tính DATEDIFF(OrderDate, JoinDate) và sắp xếp ở ORDER BY.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select o.OrderID, o.OrderDate, c.JoinDate,c.CustomerName, datediff(o.OrderDate,c.JoinDate) as DaysFromJoinToOrder
from orders o
inner join customers c
on o.CustomerID = c.CustomerID
where o.status = 'Shipped' and o.OrderDate >= '2026-01-01'
order by DaysFromJoinToOrder desc;




-- --------------------------------------------------------------------
-- [TICKET #607] (Yêu cầu từ Bộ phận Kho vận - Logistics Team)
-- "Chào team Data, để tối ưu hóa quy trình đóng gói, hãy thống kê tổng số lượng sản phẩm 
--  (TotalQuantitySold) và tổng số đơn hàng khác nhau (TotalOrdersCount) đối với các sản phẩm 
--  thuộc danh mục Thời trang ('Clothes' hoặc 'Shoes') đã giao thành công (Status = 'Shipped') 
--  cho các khách hàng sống tại thành phố Hà Nội (Hanoi).
--  Hiển thị báo cáo gồm: Tên sản phẩm (ProductName), Danh mục (Category), Tổng số lượng đã bán, 
--  và Tổng số đơn hàng chứa sản phẩm đó. Sắp xếp số lượng bán được giảm dần (DESC)."
--  Gợi ý: Ghép 4 bảng Products, OrderDetails, Orders, và Customers. 
--        Lọc Category IN ('Clothes', 'Shoes') VÀ Status = 'Shipped' VÀ City = 'Hanoi' ở WHERE.
--        Gom nhóm theo ProductID, ProductName, Category.
--        Tính SUM(od.Quantity) và COUNT(DISTINCT od.OrderID). Sắp xếp theo tổng lượng bán giảm dần.
-- --------------------------------------------------------------------

-- SQL query của bạn:

SELECT p.ProductName, p.Category, SUM(od.Quantity) AS TotalQuantitySold, COUNT(DISTINCT od.OrderID) AS TotalOrdersCount
FROM Products p
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE p.Category IN ('Clothes', 'Shoes') AND o.Status = 'Shipped' AND c.City = 'Hanoi'
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalQuantitySold DESC;


-- --------------------------------------------------------------------
-- [TICKET #608] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chúng tôi muốn tìm các khách hàng có sức mua lớn. Hãy thống kê tổng số tiền chi trả thực tế 
--  (TotalSpent) của các khách hàng thỏa mãn các điều kiện:
--  1. Trạng thái đơn hàng là Đã giao hàng (Status = 'Shipped').
--  2. Chỉ hiển thị các khách hàng có tổng số tiền chi trả từ 300 USD trở lên (>= 300).
--  Hiển thị thông tin: Tên khách hàng (CustomerName), Email, và Tổng số tiền (TotalSpent). 
--  Sắp xếp tổng tiền chi tiêu giảm dần (DESC)."
--  Gợi ý: Ghép 3 bảng Customers, Orders, và OrderDetails.
--        Lọc Status = 'Shipped' ở WHERE.
--        Gom nhóm theo khách hàng và tính SUM(od.Quantity * od.UnitPrice) làm TotalSpent.
--        Lọc nhóm ở HAVING: TotalSpent >= 300. Sắp xếp giảm dần.
-- --------------------------------------------------------------------

-- SQL query của bạn:
SELECT c.CustomerName, c.Email, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.Status = 'Shipped'
GROUP BY c.CustomerID, c.CustomerName, c.Email
HAVING TotalSpent >= 300
ORDER BY TotalSpent DESC;



-- --------------------------------------------------------------------
-- [TICKET #609] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chào bạn, hãy liệt kê danh sách toàn bộ các khách hàng sống tại thành phố HCM 
--  kèm theo tổng số lượng sản phẩm (TotalQuantitySold) mà họ đã mua tại cửa hàng (không phân biệt trạng thái đơn hàng). 
--  Lưu ý: Phải hiển thị đầy đủ tất cả khách hàng sống tại HCM, kể cả những người chưa từng mua bất kỳ sản phẩm nào 
--  (với tổng số lượng sản phẩm hiển thị là 0). 
--  Hiển thị: Tên khách hàng (CustomerName), Email, Thành phố (City), và Tổng số lượng sản phẩm (TotalQuantitySold). 
--  Sắp xếp theo tên khách hàng tăng dần (ASC)."
--  Gợi ý: Dùng LEFT JOIN từ Customers sang Orders, ghép tiếp sang OrderDetails qua LEFT JOIN.
--        Lọc City = 'HCM' ở WHERE. 
--        Gom nhóm theo khách hàng và tính COALESCE(SUM(od.Quantity), 0). Sắp xếp tăng dần theo tên.
-- --------------------------------------------------------------------

-- SQL query của bạn:

SELECT c.CustomerName, c.Email, c.City, COALESCE(SUM(od.Quantity), 0) AS TotalQuantitySold
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE c.City = 'HCM'
GROUP BY c.CustomerID, c.CustomerName, c.Email, c.City
ORDER BY c.CustomerName ASC;






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


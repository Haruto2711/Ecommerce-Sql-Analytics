-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 04_customer_orders_integration.sql
-- CHẶNG 3: GHÉP CÁC BẢNG DỮ LIỆU (TABLE JOINS)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b task/GSHOP-400-table-joins
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #401] (Yêu cầu từ Phòng Marketing - Marketing Lead)
-- "Chào team Data, chúng tôi đang chuẩn bị gửi email cảm ơn kèm quà tặng 
--  cho các khách hàng đã đặt hàng thành công. Bạn hãy trích xuất giúp tôi 
--  danh sách gồm: Mã đơn hàng (OrderID), Ngày đặt hàng (OrderDate), 
--  Tên khách hàng (CustomerName), và Email khách hàng (Email)."
--  Gợi ý: Thực hiện INNER JOIN giữa bảng Orders và Customers qua CustomerID.
-- --------------------------------------------------------------------

-- SQL query của bạn:

select Orders.OrderID, Orders.OrderDate, Customers.CustomerName, Customers.Email
from Orders
inner join Customers
On Orders.CustomerID = Customers.CustomerID;


-- --------------------------------------------------------------------
-- [TICKET #402] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chúng tôi cần rà soát lại chi tiết doanh số bán hàng của từng mặt hàng. 
--  Bạn hãy hiển thị danh sách gồm: Mã đơn hàng (OrderID), Tên sản phẩm (ProductName), 
--  Số lượng mua (Quantity), Đơn giá bán (UnitPrice), và cột tính Thành tiền 
--  (Quantity * UnitPrice đặt tên là LineTotal). 
--  Sắp xếp danh sách theo mã đơn hàng tăng dần (ASC)."
--  Gợi ý: Thực hiện INNER JOIN giữa bảng OrderDetails và Products qua ProductID.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select orderdetails.OrderID,Products.ProductName,orderdetails.Quantity,
orderdetails.UnitPrice,(orderdetails.Quantity * orderdetails.UnitPrice) as 'LineTotal'
from orderdetails
inner join Products
on orderdetails.ProductID = Products.ProductID
order by orderdetails.OrderID asc;





-- --------------------------------------------------------------------
-- [TICKET #403] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để lập báo cáo hiệu suất bán hàng chi tiết, em hãy kết hợp 3 bảng 
--  Orders, OrderDetails và Products để lấy ra danh sách các mặt hàng đã 
--  giao hàng thành công (Status = 'Shipped'). 
--  Danh sách cần hiển thị các cột:
--  1. Mã đơn hàng (OrderID)
--  2. Ngày đặt hàng (OrderDate)
--  3. Tên sản phẩm (ProductName)
--  4. Số lượng mua (Quantity)
--  5. Thành tiền (Quantity * UnitPrice đặt tên là LineTotal)"
--  Gợi ý: Thực hiện INNER JOIN từ Orders sang OrderDetails qua OrderID, 
--        sau đó INNER JOIN tiếp sang Products qua ProductID.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select  o.OrderID, o.OrderDate, p.ProductName, od.Quantity, 
(od.Quantity * od.UnitPrice) as 'Line Total'
from orders o
inner join orderdetails od
on o.OrderID = od.OrderID
inner join products p
on od.ProductID = p.ProductID
where o.status = 'Shipped';



-- --------------------------------------------------------------------
-- [TICKET #404] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn kiểm tra xem có khách hàng nào đã đăng ký tài khoản nhưng 
--  chưa từng mua hàng hay không. Hãy liệt kê tất cả khách hàng trong hệ thống 
--  (gồm CustomerID, CustomerName, City) kèm theo mã đơn hàng (OrderID) 
--  nếu có. Hãy lọc ra những khách hàng chưa từng phát sinh bất kỳ đơn hàng nào."
--  Gợi ý: Sử dụng LEFT JOIN từ Customers sang Orders. 
--        Sau đó lọc điều kiện WHERE Orders.OrderID IS NULL ở cuối câu lệnh.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select c.CustomerID,c.CustomerName,c.City, o.OrderID
from customers c
left join orders o
on c.CustomerID = o.CustomerID
where o.OrderID is null;




-- --------------------------------------------------------------------
-- [TICKET #405] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào team Data, chúng tôi muốn biết tổng số tiền (Total Spent) mà từng 
--  khách hàng đã thực tế mua tại cửa hàng (không phân biệt trạng thái đơn hàng). 
--  Hãy hiển thị: Tên khách hàng (CustomerName), Email (Email), và Tổng số tiền 
--  đã mua (đặt tên là TotalSpent). Sắp xếp danh sách theo tổng tiền giảm dần."
--  Gợi ý: Ghép 3 bảng Customers, Orders, và OrderDetails. 
--        Sau đó GROUP BY Customers.CustomerID (hoặc CustomerName, Email) 
--        và tính SUM(Quantity * UnitPrice).
-- --------------------------------------------------------------------

-- SQL query của bạn:
select c.CustomerName, c.Email, sum(od.Quantity * od.UnitPrice) as 'TotalSpent'
from customers c
inner join orders o
on c.CustomerID = o.CustomerID
inner join orderdetails od
on o.OrderID = od.OrderID
group by c.CustomerID, c.CustomerName, c.Email
order by TotalSpent desc;



-- --------------------------------------------------------------------
-- [TICKET #406] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn thống kê số lượng sản phẩm bán ra theo từng Danh mục sản phẩm 
--  (Category) tại từng Thành phố (City) của khách hàng để tối ưu hóa quảng cáo. 
--  Hãy trích xuất báo cáo gồm: City, Category, và Tổng số lượng sản phẩm đã bán 
--  (đặt tên là TotalQuantitySold)."
--  Gợi ý: Ghép 4 bảng Customers, Orders, OrderDetails, và Products. 
--        Sau đó GROUP BY c.City, p.Category và tính SUM(od.Quantity).
-- --------------------------------------------------------------------

-- SQL query của bạn:
select c.City, p.Category, sum(od.Quantity) as 'TotalQuantitySold'
from customers c
inner join orders o
on c.CustomerID = o.CustomerID
inner join orderdetails od
on o.OrderID = od.OrderID
inner join products p
on od.ProductID = p.ProductID
group by c.City,p.Category;



-- --------------------------------------------------------------------
-- [TICKET #407] (Yêu cầu từ Bộ phận Tài chính - Finance Team)
-- "Chào bạn, hãy liệt kê toàn bộ các sản phẩm có trong hệ thống (gồm ProductID, 
--  ProductName, Category), kèm theo tổng số lượng đã bán của sản phẩm đó. 
--  Lưu ý: Phải hiển thị đầy đủ tất cả các sản phẩm có trong kho, kể cả những 
--  sản phẩm chưa từng được ai mua (với tổng số lượng bán hiển thị là 0 hoặc NULL)."
--  Gợi ý: Sử dụng LEFT JOIN từ Products sang OrderDetails qua ProductID. 
--        Sau đó GROUP BY Products.ProductID và tính SUM(od.Quantity) hoặc 
--        dùng COALESCE(SUM(od.Quantity), 0) để hiển thị số 0 thay vì NULL.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select p.ProductID, p.ProductName,p.Category, coalesce(sum(od.Quantity), 0) as 'Total Quantity'
from Products p
left join orderdetails od
on p.ProductID = od.ProductID
group by p.ProductID,p.ProductName,p.Category;




-- --------------------------------------------------------------------
-- [TICKET #408] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để phục vụ đánh giá hiệu quả của từng danh mục sản phẩm, 
--  em hãy liệt kê danh sách toàn bộ các Danh mục sản phẩm (Category) 
--  kèm theo tổng số đơn hàng (đặt tên là TotalOrders) đã chứa sản phẩm thuộc danh mục đó. 
--  Sắp xếp danh sách theo số lượng đơn hàng giảm dần."
--  Gợi ý: Ghép Products và OrderDetails qua ProductID, gom nhóm theo Category 
--        và tính COUNT(DISTINCT OrderID) để đếm số lượng đơn hàng không trùng lặp.
-- --------------------------------------------------------------------

-- SQL query của bạn:
select p.category, count(distinct od.OrderID) as 'TotalOrders'
from Products p
inner join orderdetails od
on p.ProductID = od.ProductID
group by p.category
order by TotalOrders desc;



-- --------------------------------------------------------------------
-- [TICKET #409] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Hãy tính giá trị trung bình của mỗi dòng sản phẩm bán ra (đặt tên là AverageLineValue) 
--  cho từng danh mục sản phẩm (Category) được mua bởi các khách hàng sống tại Hà Nội (City = 'Hanoi')."
--  Gợi ý: Ghép 4 bảng Products, OrderDetails, Orders, và Customers. 
--        Lọc điều kiện City = 'Hanoi' ở WHERE, gom nhóm theo Category 
--        và tính AVG(od.Quantity * od.UnitPrice).
-- --------------------------------------------------------------------

-- SQL query của bạn:
select p.Category,c.city, round(avg(od.Quantity * od.UnitPrice),1) as 'AverageLineValue'
from products p
inner join orderdetails od
on p.ProductID = od.ProductID
inner join orders o
on od.OrderID =o.OrderID
inner join customers c
on o.CustomerID = c.CustomerID
where c.City = 'Hanoi'
group by p.Category;



-- --------------------------------------------------------------------
-- [TICKET #410] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn kiểm tra tính toàn vẹn của dữ liệu đơn hàng. Hãy liệt kê tất cả 
--  các đơn hàng trong hệ thống (gồm OrderID, OrderDate, Status) của các khách hàng 
--  sống tại thành phố HCM kèm theo mã chi tiết đơn hàng (OrderDetailID) của họ 
--  nếu có. Nếu có đơn hàng nào không có chi tiết đơn hàng, cột OrderDetailID sẽ hiển thị NULL."
--  Gợi ý: Ghép bảng Customers và Orders (INNER JOIN vì mỗi đơn hàng luôn thuộc về một khách hàng), 
--        sau đó ghép tiếp sang OrderDetails bằng LEFT JOIN để giữ lại các đơn hàng 
--        không có chi tiết sản phẩm. Lọc điều kiện City = 'HCM' ở WHERE.
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select o.OrderID, o.OrderDate,o.Status, od.OrderDetailID,c.City
from customers c
inner join orders o
on c.CustomerID = o.CustomerID
left join OrderDetails od
on o.OrderID = od.OrderID
where c.City = 'HCM';






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


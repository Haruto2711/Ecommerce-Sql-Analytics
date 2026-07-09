-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 03_final_analytical_challenges.sql
-- CHẶNG CUỐI: KẾT HỢP LỌC & GOM NHÓM (COMBINED FILTERING & AGGREGATIONS)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b feature/gshop-final-basic-aggregation
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #301] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào team Data, chúng tôi muốn phân tích độ tuổi khách hàng tại khu vực
--  phía Bắc. Bạn hãy tính giúp tôi độ tuổi trung bình (Average Age) và 
--  tổng số khách hàng (Total Customer) tại từng thành phố (City). 
--  Nhưng lưu ý các điều kiện sau:
--  1. Chỉ xét khách hàng thuộc khu vực phía Bắc: 'Hanoi' hoặc 'Hai Phong'.
--  2. Chỉ hiển thị các thành phố có độ tuổi trung bình lớn hơn 28 tuổi (> 28).
--  3. Sắp xếp danh sách thành phố theo độ tuổi trung bình giảm dần (DESC)."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select City, avg(Age) as 'Average of age', count(*) as 'Total customer'
from customers
where City = 'Hanoi' or City = 'Hai Phong'
group by City
having avg(Age) > 28
order by avg(Age) desc;




-- --------------------------------------------------------------------
-- [TICKET #302] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để rà soát hiệu quả bán hàng của các sản phẩm phân khúc cao,
--  em hãy thống kê tổng số lượng sản phẩm bán được (Quantity) của từng 
--  mã sản phẩm (ProductID) trong bảng OrderDetails. Lưu ý:
--  1. Chỉ tính các sản phẩm có đơn giá bán ra (UnitPrice) từ 100 USD trở lên (>= 100).
--  2. Chỉ hiển thị các sản phẩm có tổng số lượng bán ra từ 3 cái trở lên (>= 3).
--  3. Hãy sắp xếp theo tổng số lượng bán được giảm dần (DESC)."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select ProductID, sum(Quantity) 
from OrderDetails
where UnitPrice >= 100
group by ProductID
Having sum(Quantity) >= 3
order by sum(Quantity) desc;



-- --------------------------------------------------------------------
-- [TICKET #303] (Yêu cầu từ Ban Giám đốc - Board of Directors)
-- "Chúng tôi đang khảo sát các đơn hàng gặp sự cố trong nửa đầu năm.
--  Hãy lọc ra các đơn hàng trong bảng Orders thỏa mãn:
--  1. Đơn hàng đang ở trạng thái Đang xử lý (Pending) hoặc Bị hủy (Cancelled).
--  2. Chỉ lấy các đơn hàng được tạo trước ngày 01/06/2026 (< '2026-06-01').
--  3. Hiển thị mã đơn hàng (OrderID), mã khách hàng (CustomerID), ngày đặt hàng, 
--     và trạng thái. Sắp xếp theo ngày đặt hàng giảm dần (DESC)."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select OrderID, CustomerID, OrderDate, Status from
orders
where (Status = 'Pending' or Status = 'Cancelled') and OrderDate < '2026-06-01'
order by OrderDate desc;

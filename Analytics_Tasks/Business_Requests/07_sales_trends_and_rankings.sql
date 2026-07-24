-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 07_sales_trends_and_rankings.sql
-- CHẶNG 5: CÁC HÀM PHÂN TÍCH CỬA SỔ (WINDOW FUNCTIONS)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b task/GSHOP-700-window-functions
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #701] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, để phục vụ đánh giá phân khúc giá của danh mục sản phẩm, 
--  em hãy xếp hạng (Rank) các sản phẩm trong từng danh mục (Category) dựa trên giá bán (Price) giảm dần.
--  Báo cáo cần hiển thị: Tên sản phẩm (ProductName), Danh mục (Category), Giá bán (Price), 
--  và Cột xếp hạng giá (PriceRank). 
--  Yêu cầu: Sử dụng hàm DENSE_RANK() để các sản phẩm bằng giá nhau nhận cùng hạng và không bỏ trống hạng tiếp theo."
--  Gợi ý: Cú pháp hàm xếp hạng cửa sổ:
--        DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS PriceRank
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #702] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để chuẩn bị vẽ biểu đồ xu hướng doanh thu tích lũy qua từng ngày, 
--  em hãy tính tổng doanh thu lũy kế cộng dồn (RunningTotal) theo ngày tăng dần của ngày đặt hàng. 
--  Lưu ý: Chỉ tính các đơn hàng có trạng thái Đã giao hàng (Status = 'Shipped').
--  Báo cáo cần hiển thị: Ngày đặt hàng (OrderDate), Doanh thu trong ngày (DailyRevenue - tổng tiền bán ngày hôm đó), 
--  và Doanh thu tích lũy cộng dồn (RunningTotal)."
--  Gợi ý:
--  1. Định nghĩa một CTE tính doanh thu hàng ngày:
--     WITH DailyRevenueCTE AS (
--         SELECT o.OrderDate, SUM(od.Quantity * od.UnitPrice) AS DailyRevenue
--         FROM Orders o
--         INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--         WHERE o.Status = 'Shipped'
--         GROUP BY o.OrderDate
--     )
--  2. Truy vấn chính sử dụng hàm SUM() OVER() để tính tích lũy cộng dồn theo ngày:
--     SUM(DailyRevenue) OVER (ORDER BY OrderDate ASC) AS RunningTotal
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #703] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chào bạn, để đo lường khoảng cách thời gian giữa các lần mua hàng của khách, 
--  hãy liệt kê chi tiết các đơn hàng của từng khách hàng, kèm theo ngày đặt hàng của đơn hàng ngay trước đó 
--  (PreviousOrderDate) của chính khách hàng đó. Nếu là đơn hàng đầu tiên của họ, hãy hiển thị NULL.
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Ngày đặt hiện tại (OrderDate), 
--  và Ngày đặt đơn trước đó (PreviousOrderDate). Sắp xếp theo Tên khách hàng và Ngày đặt hiện tại."
--  Gợi ý:
--  1. Ghép bảng Orders và Customers qua CustomerID.
--  2. Sử dụng hàm LAG() lấy giá trị dòng trước trong cửa sổ khách hàng:
--     LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ASC) AS PreviousOrderDate
-- --------------------------------------------------------------------

-- SQL query của bạn:



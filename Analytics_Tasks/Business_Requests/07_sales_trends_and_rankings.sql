-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 07_sales_trends_and_rankings.sql
-- CHẶNG 5: HÀM PHÂN TÍCH CỬA SỔ (WINDOW FUNCTIONS)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b task/GSHOP-700-sales-trends-rankings
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #701] (Yêu cầu từ Trưởng phòng Merchandising - Merchandising Lead)
-- "Chào em, để phục vụ rà soát chính sách giá bán của từng danh mục hàng hóa, em hãy lập 
--  báo cáo xếp hạng giá bán (PriceRank) của từng sản phẩm trong chính danh mục (Category) của nó nhé.
--  Yêu cầu: Sử dụng hàm DENSE_RANK() để xếp hạng giá bán giảm dần (giá cao nhất xếp hạng 1).
--  Hiển thị danh sách gồm: Tên sản phẩm (ProductName), Danh mục (Category), Giá bán (Price), và Xếp hạng giá (PriceRank)."
--  Gợi ý: Sử dụng hàm DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC)
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #702] (Yêu cầu từ Bộ phận Tài chính - Finance Team)
-- "Chào bạn, bộ phận tài chính cần lập biểu đồ theo dõi doanh thu lũy kế cộng dồn theo ngày 
--  của toàn bộ hệ thống để báo cáo cho Ban Giám đốc (chỉ tính đơn hàng Shipped).
--  Em hãy trích xuất danh sách gồm: Ngày đặt hàng (OrderDate), Doanh thu trong ngày (DailyRevenue), 
--  và Doanh thu lũy kế (RunningTotal) tăng dần theo ngày đặt hàng.
--  Sử dụng CTE để gom nhóm tính doanh thu theo từng ngày trước, sau đó dùng hàm cửa sổ tính lũy kế."
--  Gợi ý:
--  1. Định nghĩa CTE (DailyRevenueCTE) gom nhóm tính SUM(od.Quantity * od.UnitPrice) GROUP BY o.OrderDate.
--  2. Ở truy vấn chính: SELECT OrderDate, DailyRevenue, SUM(DailyRevenue) OVER (ORDER BY OrderDate ASC) AS RunningTotal FROM DailyRevenueCTE.
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #703] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn kiểm tra hành vi mua sắm lặp lại của khách hàng. Bạn hãy lập báo cáo hiển thị 
--  từng đơn đặt hàng kèm theo ngày đặt đơn hàng trước đó (PreviousOrderDate) của khách hàng đó nhé.
--  Hiển thị thông tin: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Ngày đặt đơn hiện tại (OrderDate), 
--  và Ngày đặt đơn hàng trước đó (PreviousOrderDate).
--  Sắp xếp kết quả theo Tên khách hàng tăng dần (ASC) và Ngày đặt đơn tăng dần (ASC)."
--  Gợi ý: Sử dụng hàm LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ASC)
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #704] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, để phục vụ việc phân loại khách hàng VIP tại từng khu vực, hãy xếp hạng các khách hàng 
--  sống tại từng thành phố theo tổng số tiền chi tiêu thực tế (TotalSpent) của họ.
--  Chỉ tính doanh số từ các đơn hàng giao thành công (Status = 'Shipped').
--  Yêu cầu: Sử dụng hàm RANK() phân nhóm theo thành phố (City) và sắp xếp tổng chi tiêu giảm dần.
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Thành phố (City), Tổng chi tiêu (TotalSpent), và Xếp hạng khách hàng (CustomerRank).
--  Sắp xếp kết quả theo Thành phố tăng dần (ASC) và Xếp hạng tăng dần (ASC)."
--  Gợi ý:
--  1. Dùng CTE để tính tổng chi tiêu thực tế của từng khách hàng kèm theo thành phố của họ.
--  2. Ở truy vấn chính: Áp dụng hàm RANK() OVER (PARTITION BY City ORDER BY TotalSpent DESC) AS CustomerRank.
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #705] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn phân tích khoảng cách thời gian giữa các lần đặt hàng của từng khách hàng. 
--  Hãy lập báo cáo hiển thị thông tin từng đơn hàng, ngày đặt đơn hiện tại (OrderDate), ngày đặt đơn của đơn hàng ngay trước đó (PreviousOrderDate), 
--  và số ngày chênh lệch giữa 2 đơn hàng liên tiếp đó (DaysBetweenOrders).
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Ngày đặt đơn (OrderDate), Ngày đặt đơn trước (PreviousOrderDate), 
--  và Số ngày chênh lệch (DaysBetweenOrders).
--  Sắp xếp theo tên khách hàng tăng dần (ASC) và ngày đặt đơn tăng dần (ASC)."
--  Gợi ý:
--  1. Định nghĩa CTE để lấy thông tin đơn hàng kèm ngày đặt đơn trước sử dụng hàm LAG() tương tự Ticket #703.
--  2. Ở truy vấn chính: Thực hiện tính toán khoảng cách ngày sử dụng DATEDIFF(OrderDate, PreviousOrderDate) AS DaysBetweenOrders.
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #706] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào em, để đánh giá tỷ trọng đóng góp của từng đơn hàng, hãy tính tỷ lệ phần trăm đóng góp doanh thu của mỗi đơn hàng (OrderRevenue) 
--  so với tổng doanh thu của chính khách hàng đó từ trước đến nay.
--  Chỉ tính doanh số từ các đơn hàng giao thành công (Status = 'Shipped').
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Doanh thu đơn hàng (OrderRevenue), 
--  và Tỷ lệ đóng góp đơn hàng (OrderRevenueContributionPercent - làm tròn 2 chữ số thập phân).
--  Sắp xếp theo tên khách hàng tăng dần (ASC) và tỷ lệ đóng góp giảm dần (DESC)."
--  Gợi ý:
--  1. Dùng CTE (OrderRevenues) để tính tổng giá trị từng đơn hàng thực tế của khách hàng (SUM(od.Quantity * od.UnitPrice)).
--  2. Ở truy vấn chính: Sử dụng hàm cửa sổ SUM(OrderRevenue) OVER (PARTITION BY CustomerID) để làm mẫu số tính tỷ trọng.
--     Tỷ lệ phần trăm đóng góp: ROUND((OrderRevenue / SUM(OrderRevenue) OVER (PARTITION BY CustomerID)) * 100, 2).
-- --------------------------------------------------------------------

-- SQL query của bạn:



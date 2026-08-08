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
select ProductName,Category,Price,  DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) as PriceRank
from products 
order by PriceRank desc;



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
WITH DailyRevenueCTE AS (
    SELECT o.OrderDate, SUM(od.Quantity * od.UnitPrice) AS DailyRevenue
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.Status = 'Shipped'
    GROUP BY o.OrderDate
)
SELECT OrderDate, DailyRevenue,
       SUM(DailyRevenue) OVER (ORDER BY OrderDate ASC) AS RunningTotal
FROM DailyRevenueCTE;



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
SELECT c.CustomerName, o.OrderID, o.OrderDate,
       LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ASC) AS PreviousOrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY c.CustomerName, o.OrderDate;




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
WITH CustomerSpending AS (
    SELECT c.CustomerID, c.CustomerName, c.City, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE o.Status = 'Shipped'
    GROUP BY c.CustomerID, c.CustomerName, c.City
)
SELECT CustomerName, City, TotalSpent,
       RANK() OVER (PARTITION BY City ORDER BY TotalSpent DESC) AS CustomerRank
FROM CustomerSpending
ORDER BY City ASC, CustomerRank ASC;




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
WITH OrderLeadLag AS (
    SELECT c.CustomerName, o.OrderID, o.CustomerID, o.OrderDate,
           LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ASC) AS PreviousOrderDate
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
)
SELECT CustomerName, OrderID, OrderDate, PreviousOrderDate,
       DATEDIFF(OrderDate, PreviousOrderDate) AS DaysBetweenOrders
FROM OrderLeadLag
ORDER BY CustomerName ASC, OrderDate ASC;




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
WITH OrderRevenues AS (
    SELECT o.OrderID, o.CustomerID, c.CustomerName, SUM(od.Quantity * od.UnitPrice) AS OrderRevenue
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.Status = 'Shipped'
    GROUP BY o.OrderID, o.CustomerID, c.CustomerName
)
SELECT CustomerName, OrderID, OrderRevenue,
       ROUND((OrderRevenue / SUM(OrderRevenue) OVER (PARTITION BY CustomerID)) * 100, 2) AS OrderRevenueContributionPercent
FROM OrderRevenues
ORDER BY CustomerName ASC, OrderRevenueContributionPercent DESC;




-- --------------------------------------------------------------------
-- [TICKET #707] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, để đánh giá dòng sản phẩm bán chạy nhất tại từng danh mục, hãy tìm top 2 sản phẩm 
--  mang lại tổng doanh thu thực tế (ProductRevenue) cao nhất trong từng danh mục (Category) sản phẩm nhé.
--  Chỉ tính doanh số từ các đơn hàng giao thành công (Status = 'Shipped').
--  Báo cáo hiển thị: Tên sản phẩm (ProductName), Danh mục (Category), Doanh thu sản phẩm (ProductRevenue), 
--  và Xếp hạng doanh thu trong danh mục (RevenueRank).
--  Sắp xếp theo Danh mục tăng dần (ASC) và Xếp hạng doanh thu tăng dần (ASC)."
--  Gợi ý:
--  1. Định nghĩa CTE thứ nhất (ProductRevenueCTE) để tính tổng doanh thu từng sản phẩm.
--  2. Định nghĩa CTE thứ hai (RankedProducts) sử dụng ROW_NUMBER() OVER (PARTITION BY Category ORDER BY ProductRevenue DESC) để xếp hạng doanh thu.
--  3. Truy vấn chính: Lọc điều kiện xếp hạng <= 2 ở WHERE.
-- --------------------------------------------------------------------

-- SQL query của bạn:
With ProductRevenueCTE as (
  select p.ProductName, p.Category, sum(od.Quantity * od.UnitPrice) as ProductRevenue
  from products p
  inner join orderdetails od on p.ProductID = od.ProductID
  inner join orders o on od.OrderID = o.OrderID
  where o.Status = 'Shipped'
  group by p.ProductID, p.ProductName, p.Category
),
RankedProducts as (
   select ProductName, Category, ProductRevenue,
          ROW_NUMBER() OVER (PARTITION BY Category ORDER BY ProductRevenue DESC) as RevenueRank
   from ProductRevenueCTE
)
select ProductName, Category, ProductRevenue, RevenueRank
from RankedProducts
where RevenueRank <= 2
order by Category asc, RevenueRank asc;


-- --------------------------------------------------------------------
-- [TICKET #708] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn xem sự thay đổi doanh số bán ra của sản phẩm so với lần bán thành công ngay trước đó.
--  Hãy lập báo cáo hiển thị từng dòng chi tiết đơn hàng Shipped gồm: 
--  Tên sản phẩm (ProductName), Mã đơn hàng (OrderID), Ngày đặt đơn (OrderDate), 
--  Số lượng bán hiện tại (CurrentQuantity), và Số lượng bán của sản phẩm đó ở lần bán Shipped ngay trước đó (PreviousQuantity).
--  Sắp xếp kết quả theo Tên sản phẩm tăng dần (ASC) và Ngày đặt đơn tăng dần (ASC)."
--  Gợi ý: Sử dụng hàm LAG(od.Quantity) OVER (PARTITION BY od.ProductID ORDER BY o.OrderDate ASC, o.OrderID ASC)
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select p.ProductName,o.OrderID, o.OrderDate,od.Quantity as CurrentQuantity,
LAG(od.Quantity) OVER (PARTITION BY od.ProductID ORDER BY o.OrderDate ASC, o.OrderID ASC) 
as PreviousQuantity
from products p
inner join orderdetails od
on p.ProductID = od.ProductID
inner join orders o
on od.OrderID = o.OrderID
where o.status = 'Shipped'
Order by p.ProductName asc, o.OrderDate asc;



-- --------------------------------------------------------------------
-- [TICKET #709] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào em, để đánh giá mức độ ổn định mua sắm của khách hàng, hãy tính doanh thu trung bình di động (Moving Average) 
--  của 3 đơn hàng gần nhất của từng khách hàng (bao gồm đơn hàng hiện tại và tối đa 2 đơn hàng trước đó).
--  Chỉ tính doanh số từ các đơn hàng giao thành công (Status = 'Shipped').
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Ngày đặt đơn (OrderDate), 
--  Doanh thu đơn hàng hiện tại (OrderRevenue), và Doanh thu trung bình di động 3 đơn (MovingAverage3Orders - làm tròn 2 chữ số thập phân).
--  Sắp xếp theo tên khách hàng tăng dần (ASC) và ngày đặt đơn tăng dần (ASC)."
--  Gợi ý:
--  1. Định nghĩa CTE (OrderRevenues) tính tổng tiền từng đơn hàng thực tế của khách hàng (SUM(od.Quantity * od.UnitPrice)).
--  2. Ở truy vấn chính: Sử dụng AVG(OrderRevenue) OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) để tính trung bình di động.
-- --------------------------------------------------------------------

-- SQL query của bạn:
WITH OrderRevenues AS (
    SELECT o.OrderID, o.CustomerID, c.CustomerName, o.OrderDate, SUM(od.Quantity * od.UnitPrice) AS OrderRevenue
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.Status = 'Shipped'
    GROUP BY o.OrderID, o.CustomerID, c.CustomerName, o.OrderDate
)
SELECT CustomerName, OrderID, OrderDate, OrderRevenue,
       ROUND(AVG(OrderRevenue) OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS MovingAverage3Orders
FROM OrderRevenues
ORDER BY CustomerName ASC, OrderDate ASC;




-- --------------------------------------------------------------------
-- [TICKET #710] (Yêu cầu từ Bộ phận Kinh doanh - Sales Lead)
-- "Chào em, để đánh giá mức độ tăng trưởng doanh thu theo từng tháng, hãy tính doanh thu thực tế 
--  của từng tháng và tỷ lệ tăng trưởng doanh thu (%) so với tháng liền trước (chỉ tính đơn hàng Shipped).
--  Báo cáo hiển thị: Tháng (YearMonth - định dạng YYYY-MM), Doanh thu tháng hiện tại (MonthlyRevenue), 
--  Doanh thu tháng trước (PreviousMonthlyRevenue), và Tỷ lệ tăng trưởng (GrowthRatePercent - làm tròn 2 chữ số thập phân).
--  Sắp xếp theo tháng tăng dần (ASC)."
--  Gợi ý:
--  1. Định nghĩa CTE thứ nhất (MonthlyRevenueCTE) gom nhóm tính tổng doanh thu theo tháng: DATE_FORMAT(o.OrderDate, '%Y-%m') và SUM(od.Quantity * od.UnitPrice).
--  2. Định nghĩa CTE thứ hai (MonthlyGrowthCTE) sử dụng LAG(MonthlyRevenue) OVER (ORDER BY YearMonth ASC) để lấy doanh thu tháng trước.
--  3. Truy vấn chính: Tính phần trăm tăng trưởng: ROUND(((MonthlyRevenue - PreviousMonthlyRevenue) / PreviousMonthlyRevenue) * 100, 2).
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #711] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi muốn xác định khách hàng có doanh số đóng góp lớn nhất (TOP 1) tại mỗi thành phố 
--  để lên kế hoạch tặng quà tri ân đặc biệt (chỉ tính doanh số từ các đơn hàng Shipped).
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Thành phố (City), và Tổng chi tiêu thực tế (TotalSpent).
--  Sắp xếp danh sách theo Thành phố tăng dần (ASC)."
--  Gợi ý:
--  1. Dùng CTE (CustomerSpending) để tính tổng chi tiêu thực tế của từng khách hàng kèm theo thành phố của họ.
--  2. Dùng CTE thứ hai (RankedCustomers) xếp hạng khách hàng trong từng thành phố bằng ROW_NUMBER() OVER (PARTITION BY City ORDER BY TotalSpent DESC) AS SpendRank.
--  3. Ở truy vấn chính: Lọc điều kiện SpendRank = 1.
-- --------------------------------------------------------------------

-- SQL query của bạn:




-- --------------------------------------------------------------------
-- [TICKET #712] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào em, để phục vụ việc chăm sóc khách hàng đặc biệt, hãy tìm các khách hàng có sự sụt giảm lớn 
--  về tổng số lượng sản phẩm đã mua ở đơn hàng Shipped gần nhất so với đơn hàng Shipped ngay trước đó của chính họ 
--  (số lượng mua ở đơn gần nhất ít hơn đơn trước đó từ 3 sản phẩm trở lên).
--  Báo cáo hiển thị: Tên khách hàng (CustomerName), Mã đơn hàng (OrderID), Số lượng đơn hiện tại (CurrentQty), 
--  Số lượng đơn trước (PreviousQty), và Số lượng sản phẩm sụt giảm (QtyDrop).
--  Sắp xếp kết quả theo tên khách hàng tăng dần (ASC)."
--  Gợi ý:
--  1. Định nghĩa CTE thứ nhất (CustomerOrderQuantities) tính tổng số lượng sản phẩm của từng đơn hàng Shipped của mỗi khách hàng.
--  2. Định nghĩa CTE thứ hai (LaggedQuantities) lấy lượng sản phẩm đơn trước đó bằng LAG(TotalQty) OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC, OrderID ASC).
--  3. Ở truy vấn chính: Lọc điều kiện (PreviousQty - CurrentQty) >= 3.
-- --------------------------------------------------------------------

-- SQL query của bạn:

















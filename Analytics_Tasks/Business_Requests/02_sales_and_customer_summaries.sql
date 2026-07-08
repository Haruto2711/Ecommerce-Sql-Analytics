-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 02_sales_and_customer_summaries.sql
-- CHẶNG 2: GOM NHÓM VÀ TÍNH TOÁN THỐNG KÊ (GROUP BY & AGGREGATIONS)
--
-- 💡 GỢI Ý GIT: Trước khi làm, hãy tạo một nhánh mới từ main:
--    git checkout main
--    git pull origin main
--    git checkout -b feature/gshop-aggregation
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #201] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chào team Data, để hiểu rõ hơn về nhóm đối tượng người dùng của hệ thống,
--  bạn hãy tính giúp tôi độ tuổi trung bình (Average Age) của toàn bộ 
--  khách hàng hiện có nhé."
-- --------------------------------------------------------------------

-- SQL query của bạn:
   Select avg(age) as 'Average Age'
   from customers;



-- --------------------------------------------------------------------
-- [TICKET #202] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Chúng tôi đang lên kế hoạch phân bổ ngân sách chạy quảng cáo theo 
--  vùng địa lý. Nhờ bạn thống kê số lượng khách hàng hiện tại ở mỗi 
--  thành phố (City) để chúng tôi đánh giá tiềm năng thị trường."
-- --------------------------------------------------------------------

-- SQL query của bạn:
  select city, count(*) 
  from customers
  group by city;



-- --------------------------------------------------------------------
-- [TICKET #203] (Yêu cầu từ Bộ phận Kho vận - Logistics Team)
-- "Để chuẩn bị cho kỳ báo cáo quý và tối ưu hóa diện tích kho bãi,
--  chúng tôi cần biết tổng số lượng hàng tồn kho (Total Stock) phân chia
--  theo từng danh mục sản phẩm (Category). Cảm ơn bạn!"
-- --------------------------------------------------------------------

-- SQL query của bạn:
select category, sum(stock) as 'Total stock'
from products
group by Category;



-- --------------------------------------------------------------------
-- [TICKET #204] (Yêu cầu từ Ban Giám đốc - Board of Directors)
-- "Chúng tôi muốn tiến hành khảo sát và tổ chức sự kiện khách hàng tại
--  các khu vực trọng điểm. Hãy tìm giúp tôi các thành phố (City) đang 
--  có từ 2 khách hàng trở lên sinh sống."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select city, count(*) as 'Total Customer'
from customers
group by city
having count(*) >= 2;




-- --------------------------------------------------------------------
-- [TICKET #205] (Yêu cầu từ Trưởng phòng Kinh doanh - Sales Lead)
-- "Chúng tôi cần theo dõi hiệu suất giá của từng danh mục sản phẩm. 
--  Bạn hãy tính giúp tôi giá bán trung bình (Average Price) và giá bán 
--  cao nhất (Maximum Price) của các sản phẩm trong mỗi danh mục (Category) nhé."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select category, avg(price) as 'Average Price', max(price) as 'Highest price'
from products
group by category;





-- --------------------------------------------------------------------
-- [TICKET #206] (Yêu cầu từ Bộ phận Vận hành - Operations Team)
-- "Chào bạn, để đánh giá hiệu quả xử lý đơn hàng, bạn hãy thống kê 
--  số lượng đơn hàng cụ thể theo từng trạng thái đơn hàng (Status) 
--  trong bảng Orders nhé."
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select status, count(*)
from Orders
group by status;



-- --------------------------------------------------------------------
-- [TICKET #207] (Yêu cầu từ Trưởng phòng Phân tích - Analytics Lead)
-- "Chào em, để chuẩn bị báo cáo doanh số nâng cao, em hãy thống kê 
--  tổng số lượng sản phẩm bán ra (Quantity) của từng mã sản phẩm (ProductID) 
--  trong bảng OrderDetails. Lưu ý: Chỉ hiển thị các sản phẩm có tổng số 
--  lượng bán ra lớn hơn 2."
-- --------------------------------------------------------------------

-- SQL query của bạn:
select ProductID, sum(Quantity) as 'Total quantity'
from OrderDetails
group by ProductID
having sum(Quantity) > 2;




-- --------------------------------------------------------------------
-- [TICKET #208] (Yêu cầu từ Bộ phận Chăm sóc Khách hàng - CS Team)
-- "Chào team Data, chúng tôi muốn thống kê độ tuổi trung bình của khách hàng 
--  tại từng thành phố (City), nhưng chỉ tính những khách hàng Nữ (Gender = 'Female'). 
--  Bạn giúp chúng tôi nhé."
-- --------------------------------------------------------------------

-- SQL query của bạn:

Select City, avg(Age) as "Average age of customer"
from customers 
Where Gender = 'Female'
Group by City;


-- --------------------------------------------------------------------
-- [TICKET #209] (Yêu cầu từ Trưởng phòng Marketing - Marketing Lead)
-- "Để chuẩn bị chiến dịch tri ân lớn, chúng tôi cần tìm các thành phố (City) 
--  có tổng số khách hàng từ 2 người trở lên, đồng thời sắp xếp danh sách 
--  các thành phố này theo số lượng khách hàng giảm dần."
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select city,count(*) as 'Total Customer'
From customers
Group by city
Having Count(*) >= 2
Order by count(*) desc;



-- --------------------------------------------------------------------
-- [TICKET #210] (Yêu cầu từ Bộ phận Tài chính - Finance Team)
-- "Chúng tôi muốn rà soát danh mục hàng hóa. Vui lòng cho biết giá bán 
--  cao nhất (Max Price) của từng danh mục sản phẩm (Category), nhưng chỉ 
--  lọc những sản phẩm có số lượng tồn kho (Stock) lớn hơn 50 nhé."
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select Category, max(Price) as 'Highest price'
From products
Where Stock > 50
group by Category;






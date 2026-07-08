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


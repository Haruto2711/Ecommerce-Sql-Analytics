-- ====================================================================
-- PROJECT: G-SHOP E-COMMERCE ANALYTICS
-- ROLE: Junior Data Analyst
-- REQUEST FILE: 01_customer_and_product_insights.sql
-- ====================================================================

USE MyDBProject;

-- --------------------------------------------------------------------
-- [TICKET #101] (Yêu cầu từ Phòng Marketing)
-- "Chào team Data, chúng tôi đang chuẩn bị một chương trình khuyến mãi
--  nhắm vào các khách hàng Nam tại TP. Hồ Chí Minh. Các bạn hãy trích xuất
--  danh sách đầy đủ của nhóm khách hàng này giúp chúng tôi nhé!"
-- --------------------------------------------------------------------

-- SQL query của bạn:
select * from Customers
where gender = 'Male' AND City = 'HCM';




-- --------------------------------------------------------------------
-- [TICKET #102] (Yêu cầu từ Phòng Quản lý Sản phẩm - Merchandising)
-- "Chào bạn, chúng tôi đang rà soát lại tồn kho ngành hàng Giày (Shoes).
--  Vui lòng lọc ra danh sách các sản phẩm Giày có giá bán dưới 150 USD
--  để chuẩn bị chạy chương trình xả kho cuối mùa."
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select * from Products
Where Category = 'Shoes' AND price < 150;




-- --------------------------------------------------------------------
-- [TICKET #103] (Yêu cầu từ Giám đốc Dịch vụ Khách hàng - CS Director)
-- "Chúng tôi muốn thực hiện một chương trình tri ân đặc biệt cho nhóm
--  khách hàng trung thành lớn tuổi nhất hệ thống. Hãy tìm giúp tôi
--  3 khách hàng có số tuổi lớn nhất trong cơ sở dữ liệu."
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select * from Customers
order by age desc
limit 3;




-- --------------------------------------------------------------------
-- [TICKET #104] (Yêu cầu từ Phòng Chăm sóc Khách hàng - CS Team)
-- "Có một khách hàng liên hệ hotline báo mất tài khoản, họ chỉ nhớ họ
--  họ Nguyễn (tên có chứa chữ 'Nguyen'). Các bạn có thể lọc nhanh
--  danh sách các khách hàng này để chúng tôi đối chiếu thông tin không?"
-- --------------------------------------------------------------------

-- SQL query của bạn:
Select * from Customers
Where CustomerName Like '%Nguyen%';

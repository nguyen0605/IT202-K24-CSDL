use social_network_pro;

EXPLAIN ANALYZE
SELECT * FROM users WHERE hometown = 'Hà nội';

CREATE INDEX idx_hometown ON users(hometown);

-- Trước khi tạo Index cho cột hometown
-- MySQL sử dụng Table Scan để thực thi truy vấn.
-- Toàn bộ bảng users phải được quét, sau đó mới áp dụng điều kiện WHERE hometown = 'Hà Nội'.
-- Chi phí ước tính (cost) cao hơn.
-- Thời gian thực thi lớn hơn và hiệu năng kém khi số lượng bản ghi tăng.
-- Kết luận: Truy vấn chưa được tối ưu do không sử dụng chỉ mục.

-- Sau khi tạo Index idx_hometown
-- MySQL sử dụng Index Lookup trên chỉ mục idx_hometown.
-- Chỉ những bản ghi thỏa điều kiện mới được truy xuất, không cần quét toàn bộ bảng.
-- Chi phí ước tính (cost) giảm đáng kể.
-- Thời gian thực thi thấp hơn và ổn định hơn khi dữ liệu lớn.
-- Kết luận: Truy vấn được tối ưu tốt nhờ sử dụng index.;

DROP INDEX idx_hometown ON users;
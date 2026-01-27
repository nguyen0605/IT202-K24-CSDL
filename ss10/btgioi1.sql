use social_network_pro;

-- 2) 
EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE YEAR(created_at) = 2026 AND user_id = 1;
-- YEAR(created_at) = 2026 là hàm bọc cột created_at
-- Khi bạn bọc cột bằng hàm như vậy, MySQL thường không dùng được index trên created_at (vì phải tính YEAR cho từng dòng)
-- ➡️ Kết quả: dù bạn có tạo index (created_at, user_id) thì EXPLAIN ANALYZE vẫn hay ra kiểu Full Table Scan / Filter khá nhiều.

CREATE INDEX idx_created_at_user_id ON posts(user_id, created_at);

EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';
  
-- Trước khi tạo index (hoặc khi dùng YEAR(created_at))
-- EXPLAIN ANALYZE thường cho thấy MySQL phải scan nhiều dòng (thường là Table scan hoặc scan lớn).
-- Sau đó mới lọc (filter) các dòng thỏa YEAR(created_at)=2026 và user_id=1.
-- Vì phải tính YEAR() cho từng dòng nên chi phí cao hơn, thời gian chạy tăng khi bảng lớn.
-- Sau khi tạo index đúng và viết WHERE dạng range
-- EXPLAIN ANALYZE sẽ chuyển sang Index range scan (hoặc dùng index để tìm nhanh).
-- MySQL có thể nhảy thẳng đến các bản ghi có user_id=1 và created_at trong khoảng năm 2026, thay vì quét cả bảng.
-- Số dòng phải đọc giảm mạnh ⇒ cost thấp hơn, thời gian chạy nhanh hơn rõ rệt khi dữ liệu nhiều.

-- 3) 
EXPLAIN ANALYZE
SELECT user_id, username, email 
FROM users
WHERE email = 'an@gmail.com';

CREATE UNIQUE INDEX idx_email ON users(email);

-- Trước khi tạo idx_email:
-- Kế hoạch thực thi thường là quét bảng (table scan) và áp dụng điều kiện lọc email='an@gmail.com'. Khi bảng users lớn, số dòng phải đọc nhiều ⇒ tốn thời gian và cost cao hơn.

-- Sau khi tạo idx_email (Unique Index):
-- MySQL chuyển sang index lookup trên idx_email. Do email là duy nhất, MySQL biết kết quả tối đa chỉ 1 dòng, nên chỉ cần truy cập index để tìm đúng bản ghi ⇒ số dòng đọc giảm mạnh, cost và thời gian thực thi giảm rõ rệt.

-- 4)
DROP INDEX idx_created_at_user_id ON posts;
DROP INDEX idx_email ON users;
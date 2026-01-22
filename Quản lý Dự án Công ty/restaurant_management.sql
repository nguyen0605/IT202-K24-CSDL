/* =========================================================
   FILE: restaurant_management.sql
   TOPIC: Restaurant Management - MySQL
   ========================================================= */

-- (Tuỳ chọn) Xoá DB cũ để chạy lại từ đầu
DROP DATABASE IF EXISTS RestaurantManagement;

-- =========================================================
-- 1) Tạo CSDL và sử dụng
-- =========================================================
CREATE DATABASE RestaurantManagement;
USE RestaurantManagement;

-- =========================================================
-- 1) Tạo bảng Customer
-- =========================================================
CREATE TABLE Customer (
    CustomerId      VARCHAR(10)  NOT NULL,
    FullName        VARCHAR(100) NOT NULL,
    Phone           VARCHAR(15)  NOT NULL UNIQUE,
    Email           VARCHAR(255) UNIQUE,
    JoinDate        DATE         NOT NULL DEFAULT (CURRENT_DATE),
    LoyaltyPoints   INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (CustomerId)
) ENGINE=InnoDB;

-- =========================================================
-- 1) Tạo bảng MenuItem
-- =========================================================
CREATE TABLE MenuItem (
    ItemId       VARCHAR(10)  NOT NULL,
    ItemName     VARCHAR(100) NOT NULL,
    Category     ENUM('Appetizer', 'Main Course', 'Dessert', 'Drink')
                 NOT NULL DEFAULT 'Main Course',
    Price        DECIMAL(8, 2) NOT NULL,
    IsAvailable  BOOLEAN      NOT NULL DEFAULT TRUE,
    Description  TEXT,
    PRIMARY KEY (ItemId)
) ENGINE=InnoDB;

-- =========================================================
-- 1) Tạo bảng OrderDetail (thực thể yếu phụ thuộc)
-- =========================================================
CREATE TABLE OrderDetail (
    OrderId          INT NOT NULL AUTO_INCREMENT,
    CustomerId       VARCHAR(10) NOT NULL,
    ItemId           VARCHAR(10) NOT NULL,
    OrderDate        DATETIME    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    Quantity         INT         NOT NULL DEFAULT 1,
    SpecialRequest   VARCHAR(255),
    TotalAmount      DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderId),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_item
        FOREIGN KEY (ItemId) REFERENCES MenuItem(ItemId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_quantity_positive
        CHECK (Quantity > 0),
    CONSTRAINT chk_totalamount_nonneg
        CHECK (TotalAmount >= 0)
) ENGINE=InnoDB;

-- =========================================================
-- 2) Chèn dữ liệu: Customer
-- =========================================================
INSERT INTO Customer (CustomerId, FullName, Phone, Email, JoinDate, LoyaltyPoints) VALUES
('CUST001', 'Nguyen Van An', '0912345678', 'an.nguyen@email.com',  '2023-01-15', 150),
('CUST002', 'Tran Thi Binh', '0912345679', 'binh.tran@email.com',  '2023-02-20', 80),
('CUST003', 'Le Van Cuong',  '0912345680', 'cuong.le@email.com',   '2023-03-10', 200),
('CUST004', 'Pham Thi Dung', '0912345681', 'dung.pham@email.com',  '2023-04-05', 50),
('CUST005', 'Hoang Van Em',  '0912345682', 'em.hoang@email.com',   '2023-05-12', 120);

-- =========================================================
-- 2) Chèn dữ liệu: MenuItem
-- =========================================================
INSERT INTO MenuItem (ItemId, ItemName, Category, Price, IsAvailable, Description) VALUES
('ITEM001', 'Goi Cuon',        'Appetizer',   45000.00, TRUE,  'Fresh spring rolls with shrimp'),
('ITEM002', 'Pho Bo',          'Main Course', 75000.00, TRUE,  'Beef noodle soup'),
('ITEM003', 'Bun Cha',         'Main Course', 68000.00, TRUE,  'Grilled pork with noodles'),
('ITEM004', 'Ca Phe Sua Da',   'Drink',       35000.00, TRUE,  'Vietnamese iced coffee'),
('ITEM005', 'Che Ba Mau',      'Dessert',     40000.00, TRUE,  'Three-color dessert'),
('ITEM006', 'Banh Mi',         'Main Course', 55000.00, FALSE, 'Vietnamese sandwich (temporarily unavailable)'),
('ITEM007', 'Goi Xoai',        'Appetizer',   60000.00, TRUE,  'Green mango salad');

-- =========================================================
-- 2) Chèn dữ liệu: OrderDetail
-- Lưu ý: OrderId là AUTO_INCREMENT nhưng vẫn có thể insert thủ công.
-- =========================================================
INSERT INTO OrderDetail (OrderId, CustomerId, ItemId, OrderDate, Quantity, SpecialRequest, TotalAmount) VALUES
(1, 'CUST001', 'ITEM001', '2023-06-01 12:30:00', 2, 'Less spicy',          90000.00),
(2, 'CUST001', 'ITEM002', '2023-06-01 12:30:00', 1, 'Extra beef',          75000.00),
(3, 'CUST002', 'ITEM003', '2023-06-02 18:15:00', 1, 'No herbs',            68000.00),
(4, 'CUST002', 'ITEM004', '2023-06-02 18:15:00', 2, 'Less sweet',          70000.00),
(5, 'CUST003', 'ITEM002', '2023-06-03 19:45:00', 3, 'Regular',            225000.00),
(6, 'CUST004', 'ITEM005', '2023-06-04 14:20:00', 2, 'Extra coconut milk',  80000.00),
(7, 'CUST005', 'ITEM007', '2023-06-05 20:00:00', 1, 'Extra shrimp',        60000.00);

-- =========================================================
-- 3) Sửa tên món ITEM001 + cập nhật giá = 50000
-- =========================================================
UPDATE MenuItem
SET ItemName = 'Goi Cuon Tom Thit',
    Price    = 50000.00
WHERE ItemId = 'ITEM001';

-- =========================================================
-- 4) Cập nhật số lượng OrderId = 4 từ 2 -> 3
-- (Gợi ý: nếu muốn đúng nghiệp vụ, nên cập nhật TotalAmount theo Quantity*Price,
-- nhưng đề chỉ yêu cầu cập nhật Quantity.)
-- =========================================================
UPDATE OrderDetail
SET Quantity = 3
WHERE OrderId = 4;

-- =========================================================
-- 5) Xoá đơn hàng OrderId = 6
-- =========================================================
DELETE FROM OrderDetail
WHERE OrderId = 6;

-- =========================================================
-- PHẦN 2: TRUY VẤN CƠ BẢN
-- =========================================================

-- 6) Khách hàng có LoyaltyPoints > 100
SELECT *
FROM Customer
WHERE LoyaltyPoints > 100;

-- 7) Món ăn category 'Main Course' và có sẵn
SELECT ItemId, ItemName, Price
FROM MenuItem
WHERE Category = 'Main Course'
  AND IsAvailable = TRUE;

-- 8) Đơn hàng của món ITEM002, sort OrderDate DESC
SELECT OrderId, CustomerId, ItemId, OrderDate, Quantity
FROM OrderDetail
WHERE ItemId = 'ITEM002'
ORDER BY OrderDate DESC;

-- 9) Khách hàng có họ "Tran" (bắt đầu bằng 'Tran ')
SELECT *
FROM Customer
WHERE FullName LIKE 'Tran %';

-- 10) Đơn hàng có TotalAmount từ 50,000 đến 100,000
SELECT *
FROM OrderDetail
WHERE TotalAmount BETWEEN 50000 AND 100000;

-- 11) 3 khách hàng tham gia sớm nhất
SELECT *
FROM Customer
ORDER BY JoinDate ASC
LIMIT 3;

-- =========================================================
-- PHẦN 3: TRUY VẤN NÂNG CAO
-- =========================================================

-- 12) Thống kê số lượng món theo category
SELECT Category, COUNT(*) AS ItemCount
FROM MenuItem
GROUP BY Category;

-- 13) Tổng tiền mỗi khách hàng đã chi tiêu
-- Dùng LEFT JOIN để vẫn hiện khách chưa mua (TotalSpent = 0)
SELECT
    c.CustomerId,
    c.FullName,
    COALESCE(SUM(od.TotalAmount), 0) AS TotalSpent
FROM Customer c
LEFT JOIN OrderDetail od
       ON od.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FullName
ORDER BY TotalSpent DESC;

-- 14) Món ăn được đặt ít nhất 2 lần (đếm số ORDER)
SELECT
    m.ItemId,
    m.ItemName
FROM MenuItem m
JOIN OrderDetail od
     ON od.ItemId = m.ItemId
GROUP BY m.ItemId, m.ItemName
HAVING COUNT(od.OrderId) >= 2;

-- =========================================================
-- PHẦN 4: TRUY VẤN PHỨC TẠP
-- =========================================================

-- 15) Khách hàng chi tiêu cao nhất
-- Cách làm: tính tổng theo khách -> lấy MAX
SELECT
    t.CustomerId,
    t.FullName,
    t.TotalSpent
FROM (
    SELECT
        c.CustomerId,
        c.FullName,
        COALESCE(SUM(od.TotalAmount), 0) AS TotalSpent
    FROM Customer c
    LEFT JOIN OrderDetail od ON od.CustomerId = c.CustomerId
    GROUP BY c.CustomerId, c.FullName
) AS t
WHERE t.TotalSpent = (
    SELECT MAX(t2.TotalSpent)
    FROM (
        SELECT
            c2.CustomerId,
            COALESCE(SUM(od2.TotalAmount), 0) AS TotalSpent
        FROM Customer c2
        LEFT JOIN OrderDetail od2 ON od2.CustomerId = c2.CustomerId
        GROUP BY c2.CustomerId
    ) AS t2
);

-- 16) Món bán chạy nhất (tổng Quantity lớn nhất)
SELECT
    m.ItemId,
    m.ItemName,
    SUM(od.Quantity) AS TotalQuantity
FROM MenuItem m
JOIN OrderDetail od ON od.ItemId = m.ItemId
GROUP BY m.ItemId, m.ItemName
HAVING SUM(od.Quantity) = (
    SELECT MAX(x.TotalQty)
    FROM (
        SELECT SUM(od2.Quantity) AS TotalQty
        FROM OrderDetail od2
        GROUP BY od2.ItemId
    ) AS x
);

-- 17) Doanh thu theo từng category
SELECT
    m.Category,
    COALESCE(SUM(od.TotalAmount), 0) AS Revenue
FROM MenuItem m
LEFT JOIN OrderDetail od ON od.ItemId = m.ItemId
GROUP BY m.Category
ORDER BY Revenue DESC;

-- 18) Top 3 khách hàng thân thiết nhất theo LoyaltyPoints
SELECT CustomerId, FullName, LoyaltyPoints
FROM Customer
ORDER BY LoyaltyPoints DESC
LIMIT 3;

-- 19) Cập nhật điểm tích luỹ: mỗi 10,000 đồng chi tiêu được 1 điểm
-- Quy tắc: LoyaltyPoints = floor(TotalSpent / 10000)
-- Lưu ý: đề không nói cộng dồn hay set lại => mình SET lại theo chi tiêu hiện tại.
UPDATE Customer c
LEFT JOIN (
    SELECT CustomerId, COALESCE(SUM(TotalAmount), 0) AS TotalSpent
    FROM OrderDetail
    GROUP BY CustomerId
) s ON s.CustomerId = c.CustomerId
SET c.LoyaltyPoints = FLOOR(COALESCE(s.TotalSpent, 0) / 10000);

-- 20) Tạo VIEW hiển thị chi tiết đơn hàng
CREATE OR REPLACE VIEW vw_OrderDetailInfo AS
SELECT
    od.OrderId,
    c.FullName AS CustomerName,
    m.ItemName AS ItemName,
    od.Quantity,
    od.TotalAmount,
    od.OrderDate
FROM OrderDetail od
JOIN Customer c ON c.CustomerId = od.CustomerId
JOIN MenuItem m ON m.ItemId = od.ItemId;

-- (Tuỳ chọn) Test view
-- SELECT * FROM vw_OrderDetailInfo ORDER BY OrderDate DESC;

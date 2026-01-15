CREATE DATABASE Ss4;
use ss4;
-- CAU 1
-- Reader
CREATE TABLE Reader (
    reader_id INT AUTO_INCREMENT,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    register_date DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY (reader_id)
);

-- Book
CREATE TABLE Book (
    book_id INT,
    book_title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    publish_year INT,

    PRIMARY KEY (book_id),
    CHECK (publish_year >= 1900)
);

-- Borrow
CREATE TABLE Borrow (
    reader_id INT,
    book_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,

    PRIMARY KEY (reader_id, book_id, borrow_date),
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- CAU 2
ALTER TABLE Reader
ADD email VARCHAR(100) UNIQUE;

ALTER TABLE Book
MODIFY author VARCHAR(150);

ALTER TABLE Borrow
ADD CONSTRAINT chk_return_date
CHECK (return_date IS NULL OR return_date >= borrow_date);

-- CAU 3
-- 1)
INSERT INTO Reader (reader_id, reader_name, phone, email, register_date) VALUES
(1, 'Nguyễn Văn An',  '0901234567', 'an.nguyen@gmail.com',  '2024-09-01'),
(2, 'Trần Thị Bình',  '0912345678', 'binh.tran@gmail.com',  '2024-09-05'),
(3, 'Lê Minh Châu',   '0923456789', 'chau.le@gmail.com',    '2024-09-10');

INSERT INTO Book (book_id, book_title, author, publish_year) VALUES
(101, 'Lập trình C căn bản', 'Nguyễn Văn A', 2018),
(102, 'Cơ sở dữ liệu',       'Trần Thị B',   2020),
(103, 'Lập trình Java',      'Lê Minh C',    2019),
(104, 'Hệ quản trị MySQL',   'Phạm Văn D',   2021);

INSERT INTO Borrow (reader_id, book_id, borrow_date, return_date) VALUES
(1, 101, '2024-09-15', NULL),
(1, 102, '2024-09-15', '2024-09-25'),
(2, 103, '2024-09-18', NULL);

-- 2)
UPDATE Borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1;

UPDATE Book
SET publish_year = 2023
WHERE publish_year >= 2021;

-- 3)
DELETE FROM Borrow
WHERE borrow_date < '2024-09-18';

-- 4)
SELECT * FROM Reader;
SELECT * FROM Book;
SELECT * FROM Borrow;
use session03;

-- Tạo bảng Student với các ràng buộc phù hợp
CREATE TABLE Student(
	student_id VARCHAR(20) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (student_id),
    UNIQUE (email)
);

-- Thêm ít nhất 3 sinh viên vào bảng
INSERT INTO Student VALUES
('SV01', 'Nguyen Van A', '2004-05-10', 'a@gmail.com'),
('SV02', 'Tran Thi B',  '2004-08-20', 'b@gmail.com'),
('SV03', 'Le Van C',    '2003-12-15', 'c@gmail.com');

-- Lấy ra toàn bộ danh sách sinh viên
SELECT * FROM Student;

-- Lấy ra mã sinh viên và họ tên của tất cả sinh viên
SELECT student_id,full_name
FROM Student;
CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

-- Câu 1:  Tạo View View_StudentBasic hiển thị: StudentID, FullName , DeptName. Sau đó truy vấn toàn bộ View_StudentBasic;
CREATE OR REPLACE VIEW View_StudentBasic AS
SELECT s.StudentID, s.FullName, d.DeptName
FROM Student s
JOIN Department d ON d.DeptID = s.DeptID;

-- Truy vấn toàn bộ View_StudentBasic
SELECT * FROM View_StudentBasic;

-- Câu 2: Regular Index cho cột FullName của Student
DROP INDEX idx_student_fullname ON Student;
CREATE INDEX idx_student_fullname ON Student(FullName);

-- Câu 3: Stored Procedure GetStudentsIT (không tham số)
DROP PROCEDURE IF EXISTS GetStudentsIT;
DELIMITER $$
CREATE PROCEDURE GetStudentsIT()
BEGIN
    SELECT s.StudentID, s.FullName, s.Gender, s.BirthDate, s.DeptID, d.DeptName
    FROM Student s
    JOIN Department d ON d.DeptID = s.DeptID
    WHERE d.DeptName = 'Information Technology';
END$$
DELIMITER ;

-- Gọi procedure GetStudentsIT
CALL GetStudentsIT();

-- Câu 4a: Tạo View View_StudentCountByDept hiển thị: DeptName, TotalStudents (số sinh viên mỗi khoa).
CREATE OR REPLACE VIEW View_StudentCountByDept AS
SELECT d.DeptName, COUNT(s.StudentID) AS TotalStudents
FROM Department d
LEFT JOIN Student s ON s.DeptID = d.DeptID
GROUP BY d.DeptName;

-- (Xem view)
SELECT * FROM View_StudentCountByDept;

-- Câu 4b: Từ View trên, viết truy vấn hiển thị khoa có nhiều sinh viên nhất.
SELECT DeptName, TotalStudents
FROM View_StudentCountByDept
WHERE TotalStudents = (SELECT MAX(TotalStudents) FROM View_StudentCountByDept);

-- Câu 5a: Viết Stored Procedure GetTopScoreStudent (IN p_CourseID)
DROP PROCEDURE IF EXISTS GetTopScoreStudent;
DELIMITER $$
CREATE PROCEDURE GetTopScoreStudent(IN p_CourseID CHAR(6))
BEGIN
    SELECT s.StudentID, s.FullName, d.DeptName, e.CourseID, c.CourseName, e.Score
    FROM Enrollment e
    JOIN Student s ON s.StudentID = e.StudentID
    JOIN Department d ON d.DeptID = s.DeptID
    JOIN Course c ON c.CourseID = e.CourseID
    WHERE e.CourseID = p_CourseID
      AND e.Score = (SELECT MAX(Score) FROM Enrollment WHERE CourseID = p_CourseID);
END$$
DELIMITER ;

-- Câu 5b: Gọi thủ tục tìm sinh viên điểm cao nhất môn Database Systems (C00001)
CALL GetTopScoreStudent('C00001');

-- Bài 6a: Tạo View_IT_Enrollment_DB (IT + đăng ký C00001) + WITH CHECK OPTION
DROP VIEW IF EXISTS View_IT_Enrollment_DB;
CREATE VIEW View_IT_Enrollment_DB AS
SELECT e.StudentID, e.CourseID, e.Score
FROM Enrollment e
JOIN Student s ON s.StudentID = e.StudentID
WHERE s.DeptID = 'IT'
  AND e.CourseID = 'C00001'
WITH CHECK OPTION;

-- (Xem view)
SELECT * FROM View_IT_Enrollment_DB;

-- Bài 6b: Procedure UpdateScore_IT_DB(IN p_StudentID, INOUT p_NewScore)
DROP PROCEDURE IF EXISTS UpdateScore_IT_DB;
DELIMITER $$
CREATE PROCEDURE UpdateScore_IT_DB(
    IN p_StudentID CHAR(6),
    INOUT p_NewScore FLOAT
)
BEGIN
    -- Nếu điểm > 10 thì gán lại = 10
    IF p_NewScore > 10 THEN
        SET p_NewScore = 10;
    END IF;

    -- Cập nhật thông qua VIEW (đảm bảo đúng WITH CHECK OPTION)
    UPDATE View_IT_Enrollment_DB
    SET Score = p_NewScore
    WHERE StudentID = p_StudentID
      AND CourseID = 'C00001';
END$$
DELIMITER ;

-- Bài 6c: CALL kiểm tra thủ tục (khai báo biến INOUT)
SET @newScore = 11.5;   -- thử nhập >10 để test
CALL UpdateScore_IT_DB('S00001', @newScore);

-- Sau khi gọi: hiển thị lại giá trị điểm mới
SELECT @newScore AS NewScoreAfterCall;

-- Kiểm tra dữ liệu trong View View_IT_Enrollment_DB
SELECT * FROM View_IT_Enrollment_DB WHERE StudentID = 'S00001';
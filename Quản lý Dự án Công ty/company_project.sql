DROP DATABASE IF EXISTS ProjectManagement;

CREATE DATABASE ProjectManagement;
use ProjectManagement;

CREATE TABLE Employee (
	EmployeeId VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    HireDate DATE NOT NULL,
    Department ENUM('IT', 'HR', 'Sales', 'Marketing', 'Finance') DEFAULT 'IT' NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Project (
	ProjectId VARCHAR(10) PRIMARY KEY NOT NULL,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Budget DECIMAL(12, 2) NOT NULL
);

CREATE TABLE ProjectAssignment (
	EmployeeId VARCHAR(10),
    ProjectId VARCHAR(10),
    Role VARCHAR(50) NOT NULL,
    HoursWorked INT NOT NULL,
    
    PRIMARY KEY (EmployeeId, ProjectId),
    FOREIGN KEY (EmployeeId) references Employee(EmployeeId),
    FOREIGN KEY (ProjectId) references Project(ProjectId)
);

-- 2) Insert Employee
INSERT INTO Employee (EmployeeId, FullName, HireDate, Department, Email, Salary) VALUES
('EMP001', 'Nguyen Van An',  '2020-03-15', 'IT',        'an.nguyen@company.com',   25000000),
('EMP002', 'Tran Thi Binh',  '2021-06-10', 'HR',        'binh.tran@company.com',   18000000),
('EMP003', 'Le Van Cuong',   '2019-11-25', 'Sales',     'cuong.le@company.com',    22000000),
('EMP004', 'Pham Thi Dung',  '2022-01-30', 'Marketing', 'dung.pham@company.com',   20000000),
('EMP005', 'Hoang Van Em',   '2020-08-12', 'Finance',   'em.hoang@company.com',    28000000);

-- Insert Project
INSERT INTO Project (ProjectId, ProjectName, StartDate, EndDate, Budget) VALUES
('PJ001', 'Website Redesign',          '2023-01-10', '2023-06-30',  500000000),
('PJ002', 'Mobile App Development',    '2023-02-15', '2023-09-30',  750000000),
('PJ003', 'Marketing Campaign Q2',     '2023-04-01', '2023-06-30',  300000000),
('PJ004', 'ERP System Upgrade',        '2023-03-01', '2023-12-31', 1200000000);

-- Insert ProjectAssignment
INSERT INTO ProjectAssignment (EmployeeId, ProjectId, Role, HoursWorked) VALUES
('EMP001', 'PJ001', 'Developer',        120),
('EMP001', 'PJ002', 'Lead Developer',   200),
('EMP002', 'PJ001', 'HR Coordinator',    80),
('EMP002', 'PJ003', 'HR Manager',        60),
('EMP003', 'PJ002', 'Sales Consultant', 100),
('EMP003', 'PJ004', 'Business Analyst', 150),
('EMP004', 'PJ003', 'Marketing Lead',   180),
('EMP004', 'PJ001', 'UX Designer',       90),
('EMP005', 'PJ004', 'Finance Controller',160);

-- 3. Sửa tên dự án có mã 'PJ001' thành 'Corporate Website Redesign 2023'.
UPDATE Project
SET ProjectName = 'Corporate Website Redesign 2023'
WHERE ProjectId = 'PJ001';

-- 4. Cập nhật số giờ làm việc của nhân viên 'EMP004' trong dự án 'PJ001' thành 110 giờ.
UPDATE ProjectAssignment
SET HoursWorked = 110
WHERE EmployeeId = 'EMP004' AND ProjectId = 'PJ001';

-- 5. Xóa phân công nhân viên có mã 'EMP002' trong dự án 'PJ003' khỏi bảng ProjectAssignment.
DELETE FROM ProjectAssignment
WHERE EmployeeId = 'EMP002' AND ProjectId = 'PJ003';

-- 6. Lấy ra toàn bộ thông tin (EmployeeId, FullName, HireDate, Department, Email, Salary) của các nhân viên thuộc phòng 'IT'.
SELECT * FROM Employee WHERE Department = 'IT';

-- 7. Lấy ra danh sách các dự án có ngày kết thúc (EndDate) trước '2023-07-01', hiển thị các cột ProjectId, ProjectName, StartDate, EndDate.
SELECT ProjectId, ProjectName, StartDate, EndDate 
FROM Project 
WHERE EndDate < '2023-07-01';

-- 8. Lấy ra danh sách phân công (EmployeeId, ProjectId, Role, HoursWorked) của dự án có mã 'PJ002', sắp xếp theo số giờ làm việc giảm dần.
SELECT EmployeeId, ProjectId, Role, HoursWorked
FROM ProjectAssignment  
ORDER BY HoursWorked DESC;

-- 9. Lấy ra tất cả thông tin của các nhân viên có họ là "Tran".
SELECT *
FROM Employee
WHERE FullName LIKE 'Tran %';      

-- 10) Phân công có HoursWorked từ 100 đến 200
SELECT EmployeeId, ProjectId, Role, HoursWorked
FROM ProjectAssignment
WHERE HoursWorked BETWEEN 100 AND 200;

-- 11) 3 nhân viên vào làm sớm nhất (HireDate ASC)
SELECT *
FROM Employee
ORDER BY HireDate ASC
LIMIT 3;

-- 12. Thống kê số lượng nhân viên theo từng phòng ban (Hiển thị: Department, EmployeeCount).
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employee
GROUP BY Department;

-- 13. Tính tổng số giờ làm việc của từng nhân viên. Hiển thị: EmployeeId, FullName và TotalHoursWorked.
SELECT
    e.EmployeeId,
    e.FullName,
    SUM(pa.HoursWorked) AS TotalHoursWorked
FROM Employee e
LEFT JOIN ProjectAssignment pa
       ON pa.EmployeeId = e.EmployeeId
GROUP BY e.EmployeeId, e.FullName;

-- 14) Dự án có ít nhất 2 nhân viên được phân công
SELECT
    p.ProjectId,
    p.ProjectName
FROM Project p
JOIN ProjectAssignment pa
     ON pa.ProjectId = p.ProjectId
GROUP BY p.ProjectId, p.ProjectName
HAVING COUNT(pa.EmployeeId) >= 2;

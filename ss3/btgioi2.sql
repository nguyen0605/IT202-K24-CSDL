use session03;

CREATE TABLE Enrollment(
	student_id VARCHAR(10) NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    enroll_date DATE,
    
    PRIMARY KEY(student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id, enroll_date) VALUES
('SV01', 'MH01', '2024-09-01'),
('SV01', 'MH02', '2024-09-02'),
('SV02', 'MH01', '2024-09-01'),
('SV02', 'MH03', '2024-09-03');

SELECT * FROM Enrollment;

SELECT * FROM Enrollment WHERE student_id = 'SV01';
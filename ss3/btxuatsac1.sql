use session03;

CREATE TABLE Score(
	student_id VARCHAR(10) NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    mid_score INT NOT NULL,
    final_score INT NOT NULL,
    
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    
    CHECK (0<=mid_score<=10),
    CHECK (0<=final_score<=10)
);

INSERT INTO Score VALUES
('SV01', 'MH01', 7.50, 8.25),
('SV02', 'MH01', 6.00, 7.00),
('SV01', 'MH02', 8.00, 9.00);

UPDATE Score
SET final_score = 10
WHERE student_id = 'SV01' AND subject_id = 'MH02';

SELECT * FROM Score;

SELECT student_id, subject_id, final_score FROM Score
WHERE final_score >= 8;
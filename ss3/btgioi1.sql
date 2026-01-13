use session03;

CREATE TABLE Subject(
	subject_id VARCHAR(10) NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    credit VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (subject_id),
    CHECK (credit>0)
);

INSERT INTO Subject VALUES 
('MH01','Math','7'),
('MH02','English','7'),
('MH03','Exercise','5');

UPDATE Subject
SET credit = '5'
WHERE subject_id = '1';

UPDATE Subject
SET subject_name = 'Giai tich'
WHERE subject_id = '1';

SELECT * FROM Subject;

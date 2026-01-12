use session02;

CREATE TABLE Student(
	student_id VARCHAR(10) NOT NULL,
    student_name VARCHAR(40) NOT NULL,
    
    PRIMARY KEY (student_id),
    UNIQUE (student_id)
);

CREATE TABLE Subject(
	subject_id VARCHAR(10) NOT NULL,
    subject_name VARCHAR(50) NOT NULL,
    credits INT NOT NULL,
    
    PRIMARY KEY (subject_id),
    UNIQUE (subject_id),
    CHECK (credits>0)
);

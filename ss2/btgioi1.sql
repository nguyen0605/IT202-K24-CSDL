use session02;

CREATE TABLE Enrollment(
	student_id VARCHAR(10) NOT NULL,
    subject_id   VARCHAR(10) NOT NULL,
    enroll_date  DATE NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);
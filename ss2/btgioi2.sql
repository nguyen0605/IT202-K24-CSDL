use session02;

CREATE TABLE Teacher(
	teacher_id VARCHAR(10) NOT NULL primary key,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL Unique
);

ALTER TABLE Subject
ADD teacher_id VARCHAR(10);

ALTER TABLE Subject
ADD CONSTRAINT fk_subject_teacher
FOREIGN KEY (teacher_id)
REFERENCES Teacher(teacher_id);
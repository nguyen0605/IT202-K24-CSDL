CREATE DATABASE MiniPJ;
use MiniPJ;

CREATE TABLE Student (
    student_id INT AUTO_INCREMENT,
    full_name  VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) NOT NULL,

    PRIMARY KEY (student_id),
    UNIQUE (email)
);

CREATE TABLE Teacher (
    teacher_id INT AUTO_INCREMENT,
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL,

    PRIMARY KEY (teacher_id),
    UNIQUE (email)
);

CREATE TABLE Course (
    course_id   INT AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    total_lessons INT NOT NULL,
    teacher_id  INT NOT NULL,

    PRIMARY KEY (course_id),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    course_id  INT NOT NULL,
    enroll_date DATE NOT NULL,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id)  REFERENCES Course(course_id)
);

CREATE TABLE Score (
    student_id  INT NOT NULL,
    course_id   INT NOT NULL,
    mid_score   DECIMAL(4,2) NOT NULL,
    final_score DECIMAL(4,2) NOT NULL,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id)  REFERENCES Course(course_id),

    CHECK (mid_score >= 0 AND mid_score <= 10),
    CHECK (final_score >= 0 AND final_score <= 10)
);

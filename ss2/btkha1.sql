create database session02;
use session02;

create table class(
	class_id varchar(10) NOT NULL,
    class_name varchar(100) NOT NULL,
    study_year int NOT NULL,
    
    PRIMARY KEY (class_id),
    CHECK (study_year >2000)
);

create table student(
	student_id varchar(10) NOT NULL,
    full_name varchar (30) NOT NULL,
    dob date NOT NULL,
    class_id varchar(10) NOT NULL,
    
    primary key(student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);


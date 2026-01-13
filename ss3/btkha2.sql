use session03;

UPDATE Student
SET email = 'newEmail@gmail.com'
WHERE student_id = 'SV03';

UPDATE Student
SET date_of_birth = '2000-01-01'
WHERE student_id = 'SV02';

DELETE FROM Student WHERE student_id = '5';

SELECT * FROM Student;
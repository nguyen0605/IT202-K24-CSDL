use social_network_pro;

DELIMITER $$
CREATE PROCEDURE CreatePostWithValidation (IN p_user_id INT, IN p_content TEXT, OUT result_message VARCHAR(255))
BEGIN
	IF char_length(p_content) < 5
		THEN SET result_message = 'Nội dung quá ngắn';
	ELSE INSERT INTO posts(user_id, content, created_at)
				VALUES(p_user_id, p_content, now());
		SET result_message = 'Thêm bài viết thành công';
	END IF;
END $$
DELIMITER ;

SET @msg = '';
CALL CreatePostWithValidation(3, 'Hôm nay trời đẹp quá', @msg);

SELECT @msg AS result_message;

SELECT *
FROM posts
WHERE user_id = 3
ORDER BY created_at DESC;

DROP PROCEDURE IF EXISTS CreatePostWithValidation;
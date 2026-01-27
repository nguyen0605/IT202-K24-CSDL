use social_network_pro;

DELIMITER $$
CREATE PROCEDURE render_post (IN p_user_id INT)
BEGIN 
	SELECT post_id, content, created_at
    FROM Posts 
    WHERE user_id = p_user_id;
END $$

DELIMITER ;

CALL render_post(1);

DROP PROCEDURE IF EXISTS render_post;
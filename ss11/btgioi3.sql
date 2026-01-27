use social_network_pro;

DELIMITER $$
CREATE PROCEDURE CalculateBonusPoints (IN p_user_id INT, INOUT p_bonus_points INT)
BEGIN 
	DECLARE total_posts INT;
	SELECT COUNT(*) INTO total_posts FROM posts WHERE user_id = p_user_id;
    IF total_posts >= 20 
		THEN SET p_bonus_points =  p_bonus_points + 20;
	ELSEIF total_posts >= 10
		THEN SET p_bonus_points = p_bonus_points + 10;
	END IF;
END $$
DELIMITER ;

SET @bonus_points = 100;
CALL CalculateBonusPoints(3, @bonus_points);

SELECT @bonus_points AS bonus_points_after_calculation;

DROP PROCEDURE IF EXISTS CalculateBonusPoints;
use ss14;

CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_likes_posts FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_likes_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT unique_like UNIQUE (post_id, user_id)
) ENGINE=InnoDB;

ALTER TABLE posts 
ADD COLUMN likes_count INT default 0;

DELIMITER $$
CREATE PROCEDURE like_post(IN p_post_id INT, IN p_user_id INT)
BEGIN	
	BEGIN
		ROLLBACK;
	END;
    
    START TRANSACTION;
    INSERT INTO likes(post_id,user_id) VALUES(p_post_id,p_user_id);
    
    UPDATE posts
	SET likes_count = likes_count + 1
    WHERE post_id = p_post_id;
    
    COMMIT;
END $$
DELIMITER ;

CALL like_post(5,1);
SELECT * FROM posts WHERE post_id = 5;


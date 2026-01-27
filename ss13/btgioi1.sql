use ss13;

DROP TRIGGER IF EXISTS before_insert_likes_no_self_like;
DELIMITER $$
CREATE TRIGGER before_insert_likes_no_self_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
	DECLARE post_owner_id INT;
    
    SELECT user_id 
	INTO post_owner_id
    FROM posts
    WHERE post_id = NEW.user_id;
    
    IF NEW.user_id = post_owner_id
    THEN SIGNAL SQLSTATE '45000'
    SET message_text = 'User không được like bài viết của chính mình';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_after_insert_likes_increase_like_count
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_after_delete_likes_decrease_like_count
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = GREATEST(like_count - 1, 0)
    WHERE post_id = OLD.post_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_after_update_likes_adjust_like_count
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    -- Nếu đổi bài được like
    IF OLD.post_id <> NEW.post_id THEN
        -- Giảm like_count của bài cũ
        UPDATE posts
        SET like_count = GREATEST(like_count - 1, 0)
        WHERE post_id = OLD.post_id;

        -- Tăng like_count của bài mới
        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;
    END IF;
END$$
DELIMITER ;

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (1, 1, NOW());

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

SELECT post_id, user_id AS owner_id, like_count
FROM posts
WHERE post_id = 4;

SELECT like_id, user_id, post_id
FROM likes
WHERE user_id = 2 AND post_id = 4
ORDER BY like_id DESC
LIMIT 1;

DELETE FROM likes
WHERE like_id = 2;

SELECT post_id, user_id AS owner_id, like_count
FROM posts
WHERE post_id = 3;

SELECT post_id, user_id AS owner_id, like_count
FROM posts
ORDER BY post_id;

SELECT *
FROM user_statistics
ORDER BY user_id;

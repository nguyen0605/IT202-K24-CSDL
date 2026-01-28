use ss14;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    CONSTRAINT fk_followers_follower
        FOREIGN KEY (follower_id) REFERENCES users(user_id),
    CONSTRAINT fk_followers_followed
        FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS follow_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    follower_id INT,
    followed_id INT,
    message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_follow_user$$
CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_cnt INT DEFAULT 0;

    -- Nếu có bất kỳ lỗi SQL nào (FK/PK/UNIQUE/SIGNAL...) → rollback + log
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ROLLBACK' AS result;
    END;

    START TRANSACTION;

    -- 1) Không tự follow chính mình
    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log(follower_id, followed_id, message)
        VALUES (p_follower_id, p_followed_id, 'Validation: cannot follow yourself');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot follow yourself';
    END IF;

    -- 2) Kiểm tra cả hai user có tồn tại không
    SELECT COUNT(*) INTO v_cnt
    FROM users
    WHERE user_id IN (p_follower_id, p_followed_id);

    IF v_cnt < 2 THEN
        INSERT INTO follow_log(follower_id, followed_id, message)
        VALUES (p_follower_id, p_followed_id, 'Validation: user not found');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    -- 3) Kiểm tra chưa follow trước đó
    SELECT COUNT(*) INTO v_cnt
    FROM followers
    WHERE follower_id = p_follower_id
      AND followed_id = p_followed_id;

    IF v_cnt > 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, message)
        VALUES (p_follower_id, p_followed_id, 'Validation: already followed');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Already followed';
    END IF;

    -- 4) OK → Insert + update counters
    INSERT INTO followers(follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;
    SELECT 'COMMIT' AS result, 'Follow successful' AS message;
END$$
DELIMITER ;

-- Chuẩn bị 2 user mẫu + lấy id
INSERT INTO users (username) VALUES ('follow_A'), ('follow_B');
SELECT user_id, username, following_count, followers_count
FROM users
WHERE username IN ('follow_A','follow_B');

-- Case 1: Thành công (COMMIT)
CALL sp_follow_user(1, 2);

SELECT * FROM followers WHERE follower_id=1 AND followed_id=2;
SELECT user_id, following_count, followers_count FROM users WHERE user_id IN (1,2);

-- Case 2: Follow lại lần 2 (ROLLBACK + log)
CALL sp_follow_user(1, 2);

SELECT * FROM followers WHERE follower_id=1 AND followed_id=2;
SELECT user_id, following_count, followers_count FROM users WHERE user_id IN (1,2);
SELECT * FROM follow_log ORDER BY log_id DESC;

-- Case 3: Tự follow (ROLLBACK + log)
CALL sp_follow_user(1, 1);
SELECT * FROM follow_log ORDER BY log_id DESC;

-- Case 4: User không tồn tại (ROLLBACK + log)
CALL sp_follow_user(1, 999999);
SELECT * FROM follow_log ORDER BY log_id DESC;

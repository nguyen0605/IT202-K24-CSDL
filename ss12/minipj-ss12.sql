CREATE DATABASE SocialNetwork;
USE SocialNetwork;

-- 1) Users
CREATE TABLE Users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2) Posts
CREATE TABLE Posts (
    post_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    content     TEXT NOT NULL,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 3) Comments
CREATE TABLE Comments (
    comment_id  INT AUTO_INCREMENT PRIMARY KEY,
    post_id     INT NOT NULL,
    user_id     INT NOT NULL,
    content     TEXT NOT NULL,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 4) Friends (bạn bè: pending/accepted)
CREATE TABLE Friends (
    user_id    INT NOT NULL,
    friend_id  INT NOT NULL,
    status     VARCHAR(20) NOT NULL,
    CHECK (status IN ('pending','accepted')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

-- 5) Likes (like bài viết)
CREATE TABLE Likes (
    user_id  INT NOT NULL,
    post_id  INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- ==============================
-- DỮ LIỆU MẪU (CƠ BẢN)
-- ==============================

INSERT INTO Users (username, password, email) VALUES
('user1', 'pass1', 'user1@gmail.com'),
('user2', 'pass2', 'user2@gmail.com'),
('user3', 'pass3', 'user3@gmail.com'),
('user4', 'pass4', 'user4@gmail.com');

INSERT INTO Posts (user_id, content) VALUES
(1, 'Bài viết số 1 của user1'),
(1, 'Bài viết số 2 của user1'),
(2, 'Bài viết số 1 của user2'),
(3, 'Bài viết số 1 của user3');

INSERT INTO Comments (post_id, user_id, content) VALUES
(1, 2, 'User2 bình luận post 1'),
(1, 3, 'User3 bình luận post 1'),
(2, 4, 'User4 bình luận post 2'),
(3, 1, 'User1 bình luận post 3');

INSERT INTO Friends (user_id, friend_id, status) VALUES
(1, 2, 'accepted'),
(2, 3, 'pending'),
(3, 4, 'accepted');

INSERT INTO Likes (user_id, post_id) VALUES
(2, 1),
(3, 1),
(4, 2),
(1, 3);

-- =========================================
-- 1) SP: Tạo bài viết (sp_create_post)
-- =========================================
DROP PROCEDURE IF EXISTS sp_create_post;
DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN  p_user_id   INT,
    IN  p_content   TEXT,
    OUT p_message   VARCHAR(255),
    OUT p_post_id   INT
)
BEGIN
    DECLARE v_user_exists INT DEFAULT 0;

    -- mặc định
    SET p_post_id = NULL;

    -- 1) Kiểm tra user tồn tại
    SELECT COUNT(*)
    INTO v_user_exists
    FROM Users
    WHERE user_id = p_user_id;

    IF v_user_exists = 0 THEN
        SET p_message = 'User không tồn tại';
    ELSEIF p_content IS NULL OR CHAR_LENGTH(TRIM(p_content)) = 0 THEN
        SET p_message = 'Nội dung không được để trống';
    ELSEIF CHAR_LENGTH(TRIM(p_content)) < 5 THEN
        SET p_message = 'Nội dung quá ngắn';
    ELSE
        -- 2) Insert bài viết
        INSERT INTO Posts(user_id, content, created_at)
        VALUES (p_user_id, p_content, CURRENT_TIMESTAMP);

        -- 3) Trả ra post_id vừa tạo
        SET p_post_id = LAST_INSERT_ID();

        SET p_message = 'Tạo bài viết thành công';
    END IF;
END$$

DELIMITER ;


-- =========================================
-- 2) SP: Đếm số bài viết của user (sp_count_posts)
-- =========================================
DROP PROCEDURE IF EXISTS sp_count_posts;
DELIMITER $$

CREATE PROCEDURE sp_count_posts(
    IN  p_user_id      INT,
    OUT p_total_posts  INT,
    OUT p_message      VARCHAR(255)
)
BEGIN
    DECLARE v_user_exists INT DEFAULT 0;

    -- mặc định
    SET p_total_posts = 0;

    -- 1) Kiểm tra user tồn tại
    SELECT COUNT(*)
    INTO v_user_exists
    FROM Users
    WHERE user_id = p_user_id;

    IF v_user_exists = 0 THEN
        SET p_message = 'User không tồn tại';
        SET p_total_posts = 0;
    ELSE
        -- 2) Đếm số bài viết
        SELECT COUNT(*)
        INTO p_total_posts
        FROM Posts
        WHERE user_id = p_user_id;

        SET p_message = 'OK';
    END IF;
END$$

DELIMITER ; 

-- Test sp_create_post
CALL sp_create_post(1, 'Hello world', @msg, @new_post_id);
SELECT @msg AS message, @new_post_id AS post_id;

-- Test sp_count_posts
CALL sp_count_posts(1, @total, @msg2);
SELECT @msg2 AS message, @total AS total_posts;

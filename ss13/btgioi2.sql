use ss13;

CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    CONSTRAINT fk_post_history_posts
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice',   '2025-01-10 12:00:00'),
(2, 'Bob first post',         '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts','2025-01-12 15:00:00');

DROP TRIGGER IF EXISTS trg_before_update_posts_save_history;
DELIMITER $$
CREATE TRIGGER trg_before_update_posts_save_history
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    -- Nếu content thay đổi thì lưu lịch sử
    IF NOT (OLD.content <=> NEW.content) THEN
        INSERT INTO post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW(), OLD.user_id);
    END IF;
END$$
DELIMITER ;

-- Update content post_id = 1
UPDATE posts
SET content = 'Hello world from Alice! (edited)'
WHERE post_id = 1;

-- Update content post_id = 4
UPDATE posts
SET content = 'Charlie sharing thoughts (updated)'
WHERE post_id = 4;

-- Xem lịch sử
SELECT history_id, post_id, old_content, new_content, changed_at, changed_by_user_id
FROM post_history
ORDER BY history_id;


-- Like một bài (ví dụ bob like post 4) -> like_count tăng
INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

SELECT post_id, like_count
FROM posts
WHERE post_id = 4;

-- Update content của post 4 -> chỉ tạo history, like_count giữ nguyên
UPDATE posts
SET content = 'Charlie sharing thoughts (updated again)'
WHERE post_id = 4;

SELECT post_id, like_count, content
FROM posts
WHERE post_id = 4;

-- Xem history của post 4
SELECT history_id, post_id, old_content, new_content, changed_at
FROM post_history
WHERE post_id = 4
ORDER BY history_id;

CREATE DATABASE ss14;
use ss14;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username)
VALUES ('nguyenvana');
SELECT * FROM users;

START TRANSACTION;
INSERT INTO posts (user_id, content)
VALUES (1, 'Đây là bài viết đầu tiên của tôi');
-- (Tuỳ chọn nhưng thực tế nên có)
UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 1;
COMMIT;

START TRANSACTION;
-- Cố ý insert user_id không tồn tại
INSERT INTO posts (user_id, content)
VALUES (999, 'Bài viết này sẽ gây lỗi');
-- Dòng này sẽ không bao giờ có tác dụng vì INSERT đã lỗi
UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 999;

-- Nếu có lỗi xảy ra
ROLLBACK;

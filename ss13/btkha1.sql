CREATE DATABASE ss13;
use ss13;

-- Tạo bảng users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

-- Tạo bảng posts
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,
    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- Trigger AFTER INSERT trên posts: Khi thêm bài đăng mới, tăng post_count của người dùng tương ứng lên 1.
DROP TRIGGER IF EXISTS increase_post_count;
DELIMITER $$
CREATE TRIGGER increase_post_count
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
	UPDATE users
    SET post_count = post_count + 1
    WHERE user_id = NEW.user_id;
END $$
DELIMITER ;

-- Trigger AFTER DELETE trên posts: Khi xóa bài đăng, giảm post_count của người dùng tương ứng đi 1.
DELIMITER $$
CREATE TRIGGER decrease_post_count_after_delete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
	UPDATE users
    SET post_count = post_count - 1
    WHERE user_id = OLD.user_id;
END $$
DELIMITER ;

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
SELECT * FROM users;

DELETE FROM posts 
WHERE post_id = 2;

SELECT * FROM users;
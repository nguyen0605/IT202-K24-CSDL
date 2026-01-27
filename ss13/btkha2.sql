use ss13;

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_likes_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_likes_posts
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

-- 3) Tạo trigger AFTER INSERT và AFTER DELETE trên likes để tự động cập nhật like_count trong bảng posts.
DELIMITER $$
CREATE TRIGGER update_like_after_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
	UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_like_after_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
	UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END $$
DELIMITER ;

-- 4) Tạo một View tên user_statistics hiển thị: user_id, username, post_count, total_likes (tổng like_count của tất cả bài đăng của người dùng đó).
CREATE OR REPLACE VIEW user_statistics AS
SELECT u.user_id, u.username, u.post_count, SUM(p.like_count) total_likes
FROM posts p
JOIN users u ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());
SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

DELETE FROM likes WHERE post_id = 4;
use social_network_pro;

CREATE INDEX idx_hometown ON users(hometown);

EXPLAIN ANALYZE
SELECT u.user_id, u.username, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà nội'
GROUP BY u.user_id, u.username, p.post_id, p.content
ORDER BY u.username desc
LIMIT 10;

DROP INDEX idx_hometown ON users;

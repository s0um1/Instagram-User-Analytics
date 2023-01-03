USE ig_clone;

-- The 5 oldest users of the Instagram from the database
SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;

-- The inactive users who have never posted a single photo on Instagram
SELECT users.id, users.username
FROM users
LEFT JOIN 
(SELECT user_id,COUNT(*) AS posts_num
FROM photos
GROUP BY user_id) AS posts
ON users.id = posts.user_id
WHERE posts_num IS NULL;

-- The winner of the contest and their details on Instagram
SELECT B.id, B.likes_num, B.user_id, users.username
FROM users
INNER JOIN
(SELECT photos.id, photos.user_id, A.likes_num
FROM photos
INNER JOIN
(SELECT photo_id, COUNT(*) AS likes_num
FROM likes
GROUP BY photo_id
ORDER BY likes_num DESC
LIMIT 1) AS A
ON photos.id = A.photo_id) B
ON users.id = B.user_id;

-- The top 5 most commonly used hashtags on the platform
SELECT tag_name, tags_count
FROM tags
INNER JOIN 
(SELECT tag_id, COUNT(*) AS tags_count
FROM photo_tags
GROUP BY tag_id
ORDER BY tags_count DESC
LIMIT 5) AS toptags
ON tags.id = toptags.tag_id

-- Insights on when to schedule an ad campaign

-- Insights on Instagram likes
SELECT COUNT(*) AS total_likes,
COUNT(DISTINCT user_id) AS unique_users,
COUNT(DISTINCT photo_id) AS unique_posts,
COUNT(DISTINCT created_at) AS unique_datetime_count
FROM likes;

SELECT EXTRACT(DAY FROM created_at) AS like_date,
COUNT(user_id) AS num_likes
FROM likes
GROUP BY 1;

-- Insights on Instagram comments
SELECT COUNT(*) AS total_comments,
COUNT(DISTINCT user_id) AS unique_users,
COUNT(DISTINCT photo_id) AS unique_posts, 
COUNT(DISTINCT created_at) AS unique_datetime_count
FROM comments;

SELECT EXTRACT(DAY FROM created_at) AS comment_date,
COUNT(user_id) AS num_comments
FROM comments
GROUP BY 1;

-- Insights on Instagram posts
SELECT COUNT(*) AS total_posts,
COUNT(DISTINCT user_id) AS unique_users,
COUNT(DISTINCT id) AS unique_posts, 
COUNT(DISTINCT created_dat) AS unique_datetime_count
FROM photos;

-- Insights on Instagram account creation
SELECT EXTRACT(DAY FROM created_at) AS creation_date,
COUNT(username) AS num_accounts
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- How many times an average user posts on Instagram
SELECT AVG(posts_count) AS avg_posts, ROUND(AVG(posts_count),0) AS avg_posts_roundval,
CEIL(AVG(posts_count)) AS avg_posts_ceilval
FROM
(SELECT user_id, count(*) AS posts_count
FROM photos
GROUP BY user_id) AS user_posts;

-- User Engagement analysis to get total number of photos on Instagram/total number of users.
SELECT (total_photos/total_users) AS total_photos_by_total_users
FROM
(SELECT COUNT(*) AS total_records, 
COUNT(DISTINCT photo_id) AS total_photos, 
COUNT(DISTINCT id) AS total_users
FROM
(SELECT * 
FROM users
LEFT JOIN 
(SELECT id AS photo_id, user_id
FROM photos) AS posts
ON users.id = posts.user_id) AS user_details) AS result

-- MoBots & Fake Accounts
SELECT id, username, num_posts_liked
FROM users
INNER JOIN
(SELECT * 
FROM
(SELECT user_id, 
COUNT(photo_id) AS num_posts_liked
FROM likes
GROUP BY user_id
ORDER BY 2 DESC) AS A
WHERE num_posts_liked=257) B
ON users.id = B.user_id;

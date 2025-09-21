-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
SELECT DISTINCT 
	username, 
    COUNT(*) AS total_submissions, 
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY 1
ORDER BY 2 DESC;

-- Q.2 Calculate the daily average points for each user.
SELECT 
    username,
    DATE(submitted_at) AS submission_date,
    AVG(points) AS avg_daily_points
FROM user_submissions
GROUP BY username, DATE(submitted_at)
ORDER BY username, submission_date;

-- Q.3 Find the top 3 users with the most positive submissions for each day.
SELECT 
	submission_date,
    username,
    positive_submissions
FROM
(SELECT 
	DATE(submitted_at) AS submission_date,
    username,
    SUM(CASE
		WHEN points > 0
        THEN 1
        ELSE 0
        END) AS positive_submissions,
    RANK() OVER (PARTITION BY DATE(submitted_at) ORDER BY SUM(CASE
		WHEN points > 0
        THEN 1
        ELSE 0
        END) DESC) AS rnk
FROM user_submissions
GROUP BY 1, 2) AS t
WHERE rnk <= 3;

-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
SELECT 
	username,
    SUM(CASE
		WHEN points < 0
        THEN 1
        ELSE 0
        END) AS incorrect_submissions
FROM user_submissions
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.5 Find the top 10 performers for each week.
SELECT *
FROM
(SELECT
	WEEK(submitted_at) AS week_no,
	username,
    SUM(points) AS total_points_earned,
    RANK() OVER (PARTITION BY WEEK(submitted_at) ORDER BY SUM(points) DESC) AS rnk
FROM user_submissions
GROUP BY 1, 2
ORDER BY 1, 3 DESC) AS k
WHERE rnk <= 10
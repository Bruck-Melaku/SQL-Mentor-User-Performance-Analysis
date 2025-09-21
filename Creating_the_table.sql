DROP TABLE user_submissions; 
CREATE TABLE user_submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at DATETIME,
    username VARCHAR(50)
);




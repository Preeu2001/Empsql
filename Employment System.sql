CREATE DATABASE EmploymentSystem;
USE EmploymentSystem;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for job postings
CREATE TABLE JobPostings (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100),
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for applications
CREATE TABLE Applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    job_id INT NOT NULL,
    status ENUM('Submitted', 'Reviewed', 'Shortlisted', 'Rejected', 'Hired') DEFAULT 'Submitted',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES JobPostings(job_id) ON DELETE CASCADE
);

-- Table for tracking employment lifecycle
CREATE TABLE Employment (
    employment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    job_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Active', 'Terminated', 'Resigned', 'Completed') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES JobPostings(job_id) ON DELETE CASCADE
);
drop table Employment;
-- Insert employment records into the Employment table
INSERT INTO Employment (user_id, job_id, start_date, end_date, status) VALUES 
(1, 1, '2023-01-01', '2023-12-31', 'Completed'), -- John Doe employed as Software Engineer
(2, 2, '2024-01-15', NULL, 'Active');          -- Jane Smith employed as Data Analyst


-- Insert sample data for testing
INSERT INTO Users (username, email, password_hash) VALUES 
('JohnDoe', 'johndoe@example.com', 'hashedpassword1'),
('JaneSmith', 'janesmith@example.com', 'hashedpassword2');

INSERT INTO JobPostings (title, description, location, salary) VALUES
('Software Engineer', 'Develop and maintain software systems.', 'New York, NY', 85000.00),
('Data Analyst', 'Analyze data to support business decisions.', 'San Francisco, CA', 75000.00);

INSERT INTO Applications (user_id, job_id, status) VALUES 
(1, 1, 'Submitted'),
(2, 2, 'Reviewed');

select * from Employment;


-- Example query: Retrieve all applications by a specific user
SELECT 
    a.application_id,
    u.username,
    j.title AS job_title,
    a.status,
    a.applied_at
FROM 
    Applications a
JOIN Users u ON a.user_id = u.user_id
JOIN JobPostings j ON a.job_id = j.job_id
WHERE u.username = 'JohnDoe';

-- Example query: Retrieve the employment lifecycle for a specific user
SELECT 
    e.employment_id,
    u.username,
    j.title AS job_title,
    e.start_date,
    e.end_date,
    e.status
FROM 
    Employment e
JOIN Users u ON e.user_id = u.user_id
JOIN JobPostings j ON e.job_id = j.job_id
WHERE u.username = 'JohnDoe';


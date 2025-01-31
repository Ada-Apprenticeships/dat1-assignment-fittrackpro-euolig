-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role

SELECT staff_id, first_name, last_name, position AS role
FROM staff;

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days

SELECT 
personal_training_sessions.staff_id AS trainer_id, 
staff.first_name || ' ' || staff.last_name AS trainer_name,
COUNT(*) AS session_count
FROM 
personal_training_sessions
LEFT JOIN
staff ON personal_training_sessions.staff_id = staff.staff_id
WHERE 
personal_training_sessions.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
AND staff.position = 'Trainer' 
GROUP BY 
personal_training_sessions.staff_id, staff.first_name || ' ' || staff.last_name
HAVING 
session_count > 1;
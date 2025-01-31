-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer

SELECT personal_training_sessions.session_id, members.first_name || ' ' || members.last_name AS member_name, session_date, start_time, end_time
FROM personal_training_sessions
LEFT JOIN 
members ON personal_training_sessions.member_id = members.member_id
LEFT JOIN 
staff ON personal_training_sessions.staff_id = staff.staff_id
WHERE staff.first_name = 'Ivy' AND staff.last_name = 'Irwin';

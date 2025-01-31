-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships

SELECT memberships.member_id, members.first_name, members.last_name, type AS membership_type, members.join_date
FROM memberships
LEFT JOIN 
members ON memberships.member_id = members.member_id
WHERE memberships.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type


SELECT 
memberships.type AS membership_type, 
CAST(AVG((strftime('%s', attendance.check_out_time) - strftime('%s', attendance.check_in_time)) / 60) AS REAL) AS avg_visit_duration_minutes
FROM 
memberships
JOIN 
attendance ON memberships.member_id = attendance.member_id
GROUP BY 
membership_type;

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

SELECT memberships.member_id, first_name, last_name, email, end_date
FROM memberships
LEFT JOIN   
members ON memberships.member_id = members.member_id
WHERE end_date BETWEEN date('now') AND date('now', '+1 year');
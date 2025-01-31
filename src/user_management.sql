-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members

SELECT member_id, first_name, last_name, email, join_date
FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information

UPDATE members
SET phone_number = '555-9876', email = 'emily.jones.updates@email.com'
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members

SELECT COUNT (DISTINCT member_id) AS total_members
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations

SELECT members.member_id, members.first_name, 
members.last_name, 
COUNT(class_attendance.class_attendance_id) AS registration_count
FROM 
members
LEFT JOIN 
class_attendance ON members.member_id = class_attendance.member_id
GROUP BY 
members.member_id, members.first_name, members.last_name
ORDER BY 
registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

SELECT members.member_id, members.first_name, 
members.last_name, 
COUNT(class_attendance.class_attendance_id) AS registration_count
FROM 
members
LEFT JOIN 
class_attendance ON members.member_id = class_attendance.member_id
GROUP BY 
members.member_id, members.first_name, members.last_name
ORDER BY 
registration_count
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT 
(COUNT(DISTINCT class_attendance.member_id) * 100.0) / (SELECT COUNT(*) FROM members) AS percentage_attended
FROM 
class_attendance
WHERE 
class_attendance.attendance_status = 'Attended';
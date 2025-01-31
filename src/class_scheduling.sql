-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
classes.class_id, 
classes.name AS class_name, 
staff.first_name || ' ' || staff.last_name AS instructor_name
FROM 
classes
LEFT JOIN
staff ON classes.location_id = staff.location_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT class_schedule.class_id, classes.name, class_schedule.start_time, class_schedule.end_time, classes.capacity AS available_spots
FROM 
class_schedule
LEFT JOIN
classes ON class_schedule.class_id = classes.class_id
WHERE
class_schedule.start_time LIKE '%2025-02-01%';

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT 
(SELECT schedule_id
 FROM class_schedule
 WHERE class_id = 3 AND start_time LIKE '2025-02-01%'),
11,
'Registered'
WHERE NOT EXISTS (
SELECT 1
FROM class_attendance
WHERE schedule_id = SELECT schedule_id
FROM class_schedule
WHERE class_id = 3 AND start_time LIKE '2025-02-01%'
      AND member_id = 11
);


-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;


-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT 
classes.class_id, 
classes.name AS class_name, 
COUNT(class_attendance.member_id) AS registration_count
FROM 
classes
LEFT JOIN 
class_schedule ON classes.class_id = class_schedule.class_id
LEFT JOIN 
class_attendance ON class_schedule.schedule_id = class_attendance.schedule_id
GROUP BY 
classes.class_id, classes.name
ORDER BY 
registration_count DESC
LIMIT 
3;


-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT 
CAST (COUNT(DISTINCT class_attendance.schedule_id) AS REAL) / COUNT(DISTINCT members.member_id) AS average_classes_per_member
FROM 
members
LEFT JOIN 
class_attendance ON members.member_id = class_attendance.member_id;
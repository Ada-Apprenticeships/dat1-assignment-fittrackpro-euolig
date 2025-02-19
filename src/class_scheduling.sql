-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

SELECT 
    c.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM 
    classes c
LEFT JOIN 
    staff s ON c.location_id = s.location_id;


-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    c.capacity AS available_spots
FROM 
    class_schedule cs
LEFT JOIN 
    classes c ON cs.class_id = c.class_id
WHERE 
    cs.start_time LIKE '%2025-02-01%';


-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT 
    (
        SELECT schedule_id
        FROM class_schedule
        WHERE class_id = 3 
        AND start_time LIKE '2025-02-01%'
    ),
    11,
    'Registered'
WHERE NOT EXISTS (
    SELECT 1
    FROM class_attendance
    WHERE schedule_id = (
        SELECT schedule_id
        FROM class_schedule
        WHERE class_id = 3 
        AND start_time LIKE '2025-02-01%'
        AND member_id = 11
    )
);


-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

DELETE FROM 
    class_attendance
WHERE 
    schedule_id = 7 
    AND member_id = 2;


-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

SELECT 
    c.class_id,
    c.name AS class_name,
    COUNT(ca.member_id) AS registration_count
FROM 
    classes c
LEFT JOIN 
    class_schedule cs ON c.class_id = cs.class_id
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id
GROUP BY 
    c.class_id, c.name
ORDER BY 
    registration_count DESC
LIMIT 
    3;


-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member

SELECT 
    CAST(COUNT(DISTINCT ca.schedule_id) AS REAL) / COUNT(DISTINCT m.member_id) AS average_classes_per_member
FROM 
    members m
LEFT JOIN 
    class_attendance ca ON m.member_id = ca.member_id;
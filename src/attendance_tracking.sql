-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit

INSERT INTO attendance (member_id, location_id, check_in_time)
SELECT 7, 1, strftime('%Y-%m-%d %H:%M:%S', 'now')
WHERE NOT EXISTS (
    SELECT 1
    FROM attendance
    WHERE member_id = 7
    AND location_id = 1
    AND date(check_in_time) = date('now')
);


-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history

SELECT 
    DATE(check_in_time) AS visit_date, 
    TIME(check_in_time) AS check_in_time, 
    TIME(check_out_time) AS check_out_time
FROM 
    attendance
WHERE 
    member_id = 5;

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits

SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        ELSE 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM 
    attendance
GROUP BY 
    day_of_week
ORDER BY 
    visit_count DESC
LIMIT 1;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location

SELECT 
    l.name AS location_name,
    CAST(COUNT(a.attendance_id) AS REAL) / COUNT(DISTINCT DATE(a.check_in_time)) AS avg_daily_attendance
FROM 
    locations l
LEFT JOIN 
    attendance a ON l.location_id = a.location_id
GROUP BY 
    l.location_id, l.name;



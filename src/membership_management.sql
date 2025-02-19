-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

PRAGMA foreign_keys = ON;

SELECT 
    ms.member_id,
    m.first_name,
    m.last_name,
    type AS membership_type,
    m.join_date
FROM 
    memberships ms
LEFT JOIN 
    members m ON ms.member_id = m.member_id
WHERE 
    ms.status = 'Active';


-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

SELECT 
    ms.type AS membership_type,
    CAST(AVG((strftime('%s', a.check_out_time) - strftime('%s', a.check_in_time)) / 60) AS REAL) AS avg_visit_duration_minutes
FROM 
    memberships ms
JOIN 
    attendance a ON ms.member_id = a.member_id
GROUP BY 
    membership_type;


-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

SELECT 
    ms.member_id, 
    first_name, 
    last_name, 
    email, 
    end_date
FROM 
    memberships ms
LEFT JOIN 
    members m ON ms.member_id = m.member_id
WHERE 
    end_date BETWEEN date('now') AND date('now', '+1 year');
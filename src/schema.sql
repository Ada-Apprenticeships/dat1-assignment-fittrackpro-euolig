-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column
.read data/sample_data.sql

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments ;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

-- Enable foreign key support

PRAGMA foreign_keys = ON;

-- Create your tables here

CREATE TABLE locations (
    location_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL,
    address       TEXT NOT NULL,
    phone_number  TEXT NOT NULL,
    email         TEXT NOT NULL,
    opening_hours TEXT
);

CREATE TABLE members (
    member_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name              TEXT NOT NULL,
    last_name               TEXT NOT NULL,
    email                   TEXT NOT NULL,
    phone_number            TEXT NOT NULL,
    date_of_birth           DATE,
    join_date               DATE,
    emergency_contact_name  TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL
);


CREATE TABLE staff (
    staff_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name    TEXT NOT NULL,
    last_name     TEXT NOT NULL,
    email         TEXT NOT NULL,
    phone_number  TEXT NOT NULL,
    position      TEXT CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date     DATE,
    location_id   INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);



CREATE TABLE equipment (
    equipment_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    name                     TEXT NOT NULL,
    type                     TEXT NOT NULL,
    purchase_date            DATE,
    last_maintenance_date    DATE,
    next_maintenance_date    DATE,
    location_id              INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name                TEXT NOT NULL,
    description         TEXT NOT NULL,
    capacity            INT,
    duration            TIME,
    location_id         INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id         INT,
    staff_id         INT,
    start_time       TIME,
    end_time         TIME,
    FOREIGN KEY (class_id) REFERENCES class(class_id)
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id            INTEGER PRIMARY KEY AUTOINCREMENT,	
    member_id                INT,	
    type                     TEXT NOT NULL,	
    start_date               DATE,	
    end_date                 DATE,	
    status	                 TEXT CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)

);

CREATE TABLE attendance (
    attendance_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id       INT,
    location_id     INT,
    check_in_time   DATETIME,
    check_out_time  DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id                                     INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id                                             INT,	
    member_id                                               INT,	
    attendance_status	                                    TEXT CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)

);

CREATE TABLE payments (
    payment_id                                               INTEGER PRIMARY KEY AUTOINCREMENT,	
    member_id                                                INT,	
    amount                                                   DECIMAL,	
    payment_date                                             DATE,	
    payment_method	                                         TEXT CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type	                                         TEXT CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id               INT,
    staff_id                INT,
    session_date            DATE,
    start_time              TIME,
    end_time                TIME,
    notes                   VARCHAR (100),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id               INT,
    measurement_date        DATE,
    weight                  DECIMAL,
    body_fat_percentage     DECIMAL,
    muscle_mass             DECIMAL,
    bmi                     DECIMAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id        INT,
    maintenance_date    DATE,
    description         VARCHAR(100),
    staff_id            INT,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);


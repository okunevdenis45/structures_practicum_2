DROP database if EXISTS access_control_db;
CREATE DATABASE access_control_db;
USE access_control_db;

DROP TABLE IF EXISTS employees;
CREATE TABLE IF NOT EXISTS employees(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    date_of_hire DATE,
    department VARCHAR(100),
    shift_type ENUM('morning', 'night') NOT NULL
);

ALTER TABLE employees CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS access_zones;
CREATE TABLE IF NOT EXISTS access_zones(
    zone_id INT AUTO_INCREMENT PRIMARY KEY,
    zone_name VARCHAR(50) NOT NULL,
    description TEXT
);

ALTER TABLE access_zones CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


DROP TABLE IF EXISTS denial_reasons;
CREATE TABLE IF NOT EXISTS denial_reasons(
    reason_id INT AUTO_INCREMENT PRIMARY KEY,
    reason_code VARCHAR(20) NOT NULL UNIQUE,
    reason_description VARCHAR(255) NOT NULL
);

ALTER TABLE denial_reasons CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


DROP TABLE IF EXISTS passes;
CREATE TABLE IF NOT EXISTS passes(
    pass_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    pass_type ENUM('permanent', 'temporary') NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    status ENUM('active', 'blocked', 'expired') DEFAULT 'active',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

ALTER TABLE passes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS history_pass;
CREATE TABLE IF NOT EXISTS history_pass(
    history_pass_id INT AUTO_INCREMENT PRIMARY KEY,
    pass_id INT NOT NULL,
    zone_id INT NOT NULL,
    reason_id INT,
    timestamp DATETIME NOT NULL,
    direction ENUM('in', 'out') NOT NULL,
    guard_id INT NOT NULL,
    notes TEXT
);

ALTER TABLE history_pass CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS guards;
CREATE TABLE guards(
    guard_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    shift_number VARCHAR(20),
    badge_number VARCHAR(50) UNIQUE NOT NULL,
    hire_date DATE
);

ALTER TABLE guards CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE history_pass ADD CONSTRAINT fk_history_pass_id
FOREIGN KEY (pass_id) REFERENCES passes(pass_id)
ON DELETE cascade;

ALTER TABLE history_pass ADD CONSTRAINT fk_history_zone_id
FOREIGN KEY (zone_id) REFERENCES access_zones(zone_id)
ON DELETE cascade;

ALTER TABLE history_pass ADD CONSTRAINT fk_history_guard_id
FOREIGN KEY (guard_id) REFERENCES guards(guard_id)
ON DELETE cascade;

ALTER TABLE history_pass ADD CONSTRAINT fk_history_reason_id
FOREIGN KEY (reason_id) REFERENCES denial_reasons(reason_id)
ON DELETE CASCADE;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('guard', 'security_chief', 'bp_office') NOT NULL
);

ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


ALTER TABLE guards ADD CONSTRAINT fk_guards_user
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON DELETE CASCADE;

DROP TABLE IF EXISTS pass_zones;
CREATE TABLE pass_zones(
    pass_id INT NOT NULL,
    zone_id INT NOT NULL,
    PRIMARY KEY (pass_id, zone_id),
    FOREIGN KEY (pass_id) REFERENCES passes(pass_id) ON DELETE CASCADE,
    FOREIGN KEY (zone_id) REFERENCES access_zones(zone_id) ON DELETE CASCADE
);

ALTER TABLE pass_zones CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;



CREATE INDEX idx_passes_employee_id ON passes(employee_id);
CREATE INDEX idx_history_pass_id ON history_pass(history_pass_id);
CREATE INDEX idx_history_timestamp ON history_pass(timestamp);
CREATE INDEX idx_employees_name ON employees(full_name);
CREATE INDEX idx_zones_name ON access_zones(zone_name);
CREATE INDEX idx_denial_code ON denial_reasons(reason_code);
CREATE INDEX idx_guards_badge ON guards(badge_number);
-- Создание пользователя и полномочия для бюро пропусков
CREATE USER 'bp_office'@'localhost' IDENTIFIED BY 'office12345';
GRANT ALL PRIVILEGES ON access_control_db.employees TO 'bp_office'@'localhost';
GRANT ALL PRIVILEGES ON access_control_db.passes TO 'bp_office'@'localhost';


-- Создание пользователя и полномочия для сотрудника охраны
CREATE USER 'security'@'localhost' IDENTIFIED BY 'security123';
GRANT INSERT ON access_control_db.history_pass TO 'security'@'localhost';

-- Создание пользователя и полномочия для начальника службы безопаности
CREATE USER 'security_chief'@'localhost' IDENTIFIED BY 'security_chief123';
GRANT SELECT ON access_control_db.employees TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.access_zones TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.denial_reasons TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.passes TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.history_pass TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.guards TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.users TO 'security_chief'@'localhost';
GRANT SELECT ON access_control_db.pass_zones TO 'security_chief'@'localhost';

FLUSH PRIVILEGES;
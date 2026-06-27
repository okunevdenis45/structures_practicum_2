CREATE DEFINER=`root`@`localhost` PROCEDURE `access_control_db`.`get_employees_on_date`(IN p_target_date DATE)
BEGIN
    SELECT
        h.pass_id,
        e.full_name AS visitor_name,
        e.department AS department,
        h.timestamp AS entry_time,
        h.direction,
        CASE
            WHEN p.status != 'active' THEN 'Неактивен'
            WHEN p.valid_from IS NULL OR DATE(h.timestamp) < p.valid_from THEN 'Ранний'
            WHEN p.valid_to IS NULL OR DATE(h.timestamp) > p.valid_to THEN 'Просрочен'
            ELSE 'OK'
        END AS status_check
    FROM history_pass h
    JOIN passes p ON h.pass_id = p.pass_id
    JOIN employees e ON p.employee_id = e.employee_id
    WHERE DATE(h.timestamp) = p_target_date
    ORDER BY h.timestamp ASC;
END

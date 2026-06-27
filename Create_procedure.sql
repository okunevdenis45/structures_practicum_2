CREATE DEFINER=`root`@`localhost` PROCEDURE `access_control_db`.`get_data_by_date`(IN target_date DATE)
begin
	SELECT 
        p.pass_id,
        e.full_name AS employee_full_name,
        e.department,
        hp.timestamp AS entry_time,
        hp.direction,
        -- Извлекаем статус из notes: если там 'Отказ', то 'Отказ', иначе считаем 'Успешно'
        CASE 
            WHEN hp.notes = 'Отказ' THEN 'Отказ'
            ELSE 'Успешно' 
        END AS pass_status
    FROM history_pass hp
    JOIN passes p ON hp.pass_id = p.pass_id
    JOIN employees e ON p.employee_id = e.employee_id
    WHERE DATE(hp.timestamp) = target_date;
END

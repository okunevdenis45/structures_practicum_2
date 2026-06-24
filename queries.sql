-- запрос: Просроченные пропуска
SELECT
    e.full_name,
    e.position,
    p.pass_type,
    p.valid_from,
    p.valid_to,
    p.status
FROM passes p
JOIN employees e ON e.employee_id = p.employee_id
AND p.valid_to IS NOT NULL
WHERE p.valid_to < NOW();

-- запрос: Количество запрещённых входов (reason_id = 3) по каждому сотруднику
SELECT 
    p.pass_id,
    e.full_name AS employee_name,
    COUNT(*) AS attempts_count
FROM history_pass hp
JOIN passes p ON p.pass_id = hp.pass_id
JOIN employees e ON e.employee_id = p.employee_id
WHERE hp.reason_id = 3
GROUP BY p.pass_id, e.full_name
ORDER BY attempts_count DESC;


-- Запрос: Кто сейчас внутри зоны А
SELECT e.full_name, e.position, e.department
FROM employees e
JOIN passes p ON e.employee_id = p.employee_id
JOIN (
    SELECT pass_id, MAX(timestamp) AS last_event_time
    FROM history_pass
    WHERE zone_id = 1
      AND notes = 'Успешно'
    GROUP BY pass_id
) hp_last ON p.pass_id = hp_last.pass_id
JOIN history_pass hp ON hp_last.pass_id = hp.pass_id
    AND hp_last.last_event_time = hp.timestamp
WHERE hp.direction = 'in';















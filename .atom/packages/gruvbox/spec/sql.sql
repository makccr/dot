-- full line comment
SELECT
  d.name AS department, e.id, full_name, max(salary),
  CASE WHEN e.type = 'p'
          THEN 'part-time'
     WHEN e.type = 'f'
          THEN 'full-time'
     ELSE 'special'
  END
FROM employees AS e
INNER JOIN departments AS d ON e.department = d.id
GROUP BY e.department
WHERE salary > (SELECT avg(salary) FROM employees)
AND e.department IS NOT NULL
ORDER BY d.name -- inline comment

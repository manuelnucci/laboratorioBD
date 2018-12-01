CREATE OR ALTER PROCEDURE consulta_3
AS
SELECT empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado
INNER JOIN area ON registro.num_area = area.num_area
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), CONVERT(date, GETDATE(), 101)) <= 30
	  AND registro.autorizado = 'No'
GROUP BY empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
HAVING COUNT(*) > 5

UNION

SELECT empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado
INNER JOIN area ON registro.num_area = area.num_area
INNER JOIN nivel_seguridad NSE ON empleado.id_nivel_seg = NSE.id_nivel_seg
INNER JOIN nivel_seguridad NSA ON area.id_nivel_seg = NSA.id_nivel_seg
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), CONVERT(date, GETDATE(), 101)) <= 30
      AND registro.autorizado = 'No'
	  AND ((NSE.nombre = 'Bajo' AND (NSA.nombre = 'Medio' OR NSA.nombre = 'Alto'))
            OR (NSE.nombre = 'Medio' AND NSA.nombre = 'Alto'));
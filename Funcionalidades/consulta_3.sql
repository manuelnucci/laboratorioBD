SELECT empleado.id_empleado, 
       empleado.nombre, 
	   empleado.apellido, 
	   empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado
INNER JOIN area ON registro.num_area = area.num_area
INNER JOIN nivel_seguridad NE ON empleado.id_nivel_seg = NE.id_nivel_seg
INNER JOIN nivel_seguridad NA ON area.num_area = NA.id_nivel_seg
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), GETDATE()) <= 30
      AND (NE.nombre = 'Alto' OR (NE.nombre = 'Medio' AND NA.nombre = 'Medio')) --Error contraseña
	  AND registro.autorizado = 'No'
GROUP BY empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
HAVING COUNT(*) > 5

UNION

SELECT DISTINCT empleado.id_empleado, 
                empleado.nombre, 
				empleado.apellido, 
				empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado AND empleado.id_nivel_seg <> '1'
INNER JOIN area ON registro.num_area = area.num_area
INNER JOIN nivel_seguridad NE ON empleado.id_nivel_seg = NE.id_nivel_seg
INNER JOIN nivel_seguridad NA ON area.num_area = NA.id_nivel_seg
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), GETDATE()) <= 30
      AND registro.autorizado = 'No'
	  AND ((NE.nombre = 'Bajo' AND (NA.nombre = 'Medio' OR NA.nombre = 'Alto'))
            OR (NE.nombre = 'Medio' AND NA.nombre = 'Alto'))
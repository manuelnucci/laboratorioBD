CREATE VIEW intentos_fallidos 
AS 
  SELECT empleado.id_empleado,
         empleado.nombre,
         empleado.apellido,
         area.num_area,
         area.nombre AS 'nombre_area'
  FROM   empleado 
         INNER JOIN registro 
                 ON empleado.id_empleado = registro.id_empleado 
         INNER JOIN area 
                 ON registro.num_area = area.num_area 
  WHERE  CONVERT(date, registro.fecha_hora, 101) = GETDATE() 
         AND registro.autorizado = 'No'
  GROUP  BY empleado.id_empleado, 
            empleado.nombre, 
			empleado.apellido, 
			area.num_area, 
			area.nombre,
			registro.fecha_hora
  HAVING CONVERT(time, registro.fecha_hora) > ALL (SELECT CONVERT(time, registro.fecha_hora) 
                                                   FROM registro 
                                                   INNER JOIN empleado ON registro.id_empleado = empleado.id_empleado 
                                                   WHERE registro.id_empleado = empleado.id_empleado
						         AND CONVERT(date, registro.fecha_hora, 101) = GETDATE() 
                                                         AND registro.autorizado <> 'No')
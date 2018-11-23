CREATE VIEW intentos_fallidos AS 
SELECT empleado.id_empleado,
       empleado.nombre,
       empleado.apellido,
       area.num_area,
       area.nombre AS 'nombre_area'
FROM   empleado INNER JOIN registro ON empleado.id_empleado = registro.id_empleado 
                INNER JOIN area ON registro.num_area = area.num_area 
WHERE  CONVERT(date, registro.fecha_hora, 101) = GETDATE() 
       AND registro.autorizado = 'No' 
       AND CONVERT(time, registro.fecha_hora) = (SELECT MAX(CONVERT(time, registro.fecha_hora)) 
                                                 FROM registro 
                                                 WHERE registro.id_empleado = empleado.id_empleado
            				                    AND CONVERT(date, registro.fecha_hora, 101) = GETDATE());
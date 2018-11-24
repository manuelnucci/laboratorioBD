DROP VIEW IF EXISTS intentos_fallidos;
GO

CREATE VIEW intentos_fallidos AS 
SELECT empleado.id_empleado,
       empleado.nombre,
       empleado.apellido,
       area.num_area,
       area.nombre AS 'nombre_area'
FROM   empleado INNER JOIN registro R1 ON empleado.id_empleado = registro.id_empleado 
                INNER JOIN area ON registro.num_area = area.num_area 
WHERE  CONVERT(date, R1.fecha_hora, 101) = GETDATE() 
       AND R1.autorizado = 'No' 
       AND R1.accion = 'Ingreso'
       AND CONVERT(time, R1.fecha_hora) = (SELECT MAX(CONVERT(time, R2.fecha_hora)) 
                                                 FROM registro R2
                                                 WHERE R2.id_empleado = empleado.id_empleado
                                                       AND registro.accion = 'Ingreso'
            				                           AND CONVERT(date, R2.fecha_hora, 101) = GETDATE());
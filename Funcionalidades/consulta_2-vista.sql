CREATE OR ALTER VIEW intentos_fallidos 
AS 
SELECT empleado.id_empleado,
       empleado.nombre,
       empleado.apellido,
       area.num_area,
       area.nombre AS 'nombre_area'
FROM   empleado INNER JOIN registro R1 ON empleado.id_empleado = R1.id_empleado 
                INNER JOIN area ON R1.num_area = area.num_area 
WHERE  CONVERT(date, R1.fecha_hora, 101) = CONVERT(date, GETDATE(), 101) 
       AND R1.autorizado = 'No' 
       AND R1.accion = 'Ingreso'
       AND CONVERT(time(0), R1.fecha_hora) = (SELECT MAX(CONVERT(time(0), R2.fecha_hora)) 
                                              FROM registro R2
                                              WHERE R2.id_empleado = empleado.id_empleado
                                                    AND R2.accion = 'Ingreso'
            				                AND CONVERT(date, R2.fecha_hora, 101) = CONVERT(date, GETDATE(), 101));
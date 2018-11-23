-- 1 - Consulta (división con la forma enseñada por Leticia)
SELECT empleado.nombre, 
       empleado.apellido, 
       empleado.id_empleado 
FROM   empleado 
WHERE  NOT EXISTS (SELECT * 
                   FROM area 
                   WHERE NOT EXISTS (SELECT * 
                                     FROM acceso 
                                     WHERE acceso.id_empleado = empleado.id_empleado AND
                                           acceso.num_area = area.num_area));
-- 1 - Consulta (división con EXCEPT)
SELECT empleado.nombre, 
       empleado.apellido, 
       empleado.id_empleado 
FROM   empleado 
/* No haría falta este INNER JOIN ya que el INNER JOIN de la segunda subquery me filtra a los empleados
   no profesionales */ 
/* INNER JOIN empleado_no_profesional ON empleado.id_empleado = empleado_no_profesional.id_empleado */
WHERE  NOT EXISTS ((SELECT area.num_area 
                    FROM   area 
                    WHERE  area.id_nivel_seg = empleado.id_nivel_seg) 
                   EXCEPT 
                   (SELECT acceso.num_area 
                    FROM   acceso 
                           /* Tengo la garantía que en la tabla acceso sólo aparecen id's de empleados no profesionales */
                           INNER JOIN empleado 
                                   ON acceso.id_empleado = empleado.id_empleado));

-- 1 - Consulta (división con la forma enseñada por Leticia)
SELECT empleado.nombre, 
       empleado.apellido, 
       empleado.id_empleado 
FROM   empleado 
WHERE  NOT EXISTS (SELECT * 
                   FROM   area 
                   WHERE  area.id_nivel_seg = empleado.id_nivel_seg 
                          AND NOT EXISTS (SELECT * 
                                          FROM   acceso 
                                                 INNER JOIN empleado 
                                                         ON acceso.id_empleado = empleado.id_empleado));
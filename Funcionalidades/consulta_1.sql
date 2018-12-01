CREATE OR ALTER PROCEDURE consulta_1
AS
SELECT E.nombre, E.apellido, E.id_empleado 
FROM   empleado E
WHERE  NOT EXISTS (SELECT * 
                   FROM area A
                   WHERE A.id_nivel_seg= E.id_nivel_seg AND NOT EXISTS (SELECT * 
																		FROM acceso AC
																		WHERE AC.id_empleado = E.id_empleado AND
																			  AC.num_area = A.num_area));
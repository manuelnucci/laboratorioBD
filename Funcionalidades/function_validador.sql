SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION validador
    (@id_empleado INT,
    @num_area INT,
    @tipo_empleado INT) -- 1 Emp Jerarq, 2 EPPermanente, 3 EPContratado, 4 EmpNoProf
RETURNS INT
AS
BEGIN
    DECLARE
        @id_nivel_seg_emp INT,
        @nombre_id_nivel_seg_emp VARCHAR(15),
        @id_nivel_seg_area INT,
        @nombre_id_nivel_seg_area VARCHAR(15),
		@nReturn INT;

    SELECT @id_nivel_seg_emp = E.id_nivel_seg, @nombre_id_nivel_seg_emp = NS.nombre
    FROM empleado E
    INNER JOIN nivel_seguridad NS ON E.id_nivel_seg = NS.id_nivel_seg
    WHERE E.id_empleado = @id_empleado;

    SELECT @id_nivel_seg_area = A.id_nivel_seg, @nombre_id_nivel_seg_area = NS.nombre
    FROM area A
    INNER JOIN nivel_seguridad NS ON A.id_nivel_seg = NS.id_nivel_seg
    WHERE A.num_area = @num_area;

    IF @id_nivel_seg_emp = @id_nivel_seg_area OR
        (@tipo_empleado <> 4 AND
        (@nombre_id_nivel_seg_emp = 'Alto' OR
        (@nombre_id_nivel_seg_emp = 'Medio' AND @nombre_id_nivel_seg_area = 'Bajo')))
        SET @nReturn = 1;
    ELSE
        SET @nReturn = 0;
    RETURN @nReturn;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_area_emp_jerarq_update 
ON dbo.empleado_jerarquico
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @num_area INT,
        @fecha_asignacion DATE;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, num_area, fecha_asignacion
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @num_area, @fecha_asignacion;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 1) = 1
        BEGIN
            UPDATE [dbo].[empleado_jerarquico]
            SET [id_empleado] = @id_empleado
               ,[num_area] = @num_area
               ,[fecha_asignacion] = @fecha_asignacion
            WHERE id_empleado = @id_empleado
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + 
                  ' no ha podido ser modificado.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @num_area, @fecha_asignacion;
    END;
    CLOSE cur;
    DEALLOCATE cur;
END;
GO
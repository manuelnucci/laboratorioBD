SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

DROP TRIGGER IF EXISTS validar_area_emp_no_prof_update;
GO

CREATE TRIGGER validar_area_emp_no_prof_update 
ON dbo.acceso
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @id_franja INT,
        @num_area INT;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, id_franja, num_area
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @id_franja, @num_area;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 4) = 1
        BEGIN
            UPDATE [dbo].[acceso]
            SET [id_empleado] = @id_empleado
               ,[id_franja] = @id_franja
               ,[num_area] = @num_area
            WHERE id_empleado = @id_empleado AND id_franja = @id_franja
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + @id_empleado + ' que lo vincula con una 
                   franja horaria y un área no pudo ser modificado por ser inválida el área.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @id_franja, @num_area;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_area_emp_prof_perm_insert 
ON dbo.empleado_prof_permanente
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @num_area INT;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, num_area
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @num_area;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 2) = 1
        BEGIN
            INSERT INTO [dbo].[empleado_prof_permanente]
                        ([id_empleado]
                        ,[num_area])
            VALUES
                (@id_empleado
                ,@num_area);
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + 
                  ' no ha podido ser insertado.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @num_area;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_area_emp_no_prof_insert
ON dbo.acceso
INSTEAD OF INSERT
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
            INSERT INTO [dbo].[acceso]
                       ([id_empleado]
                       ,[id_franja]
                       ,[num_area])
            VALUES
                (@id_empleado
                ,@id_franja 
                ,@num_area);
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + ' que lo 
                   vincula con una franja horaria y un área no pudo ser insertado por ser inválida 
                   el área.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @id_franja, @num_area;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
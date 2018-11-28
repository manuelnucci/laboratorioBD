SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_area_emp_prof_contr_insert 
ON dbo.contratado_en
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @id_trabajo INT,
        @num_area INT,
        @inicio_contrato DATE,
        @fin_contrato DATE,
        @cond_trabajo INT;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, id_trabajo, num_area, inicio_contrato, fin_contrato
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @id_trabajo, @num_area, @inicio_contrato, @fin_contrato;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 3) = 1 AND DATEDIFF(day, @inicio_contrato, @fin_contrato) > 0
        BEGIN
            SELECT cond_trabajo = COUNT(*)
            FROM contratado_en
            WHERE id_trabajo = @id_trabajo
            GROUP BY id_trabajo, num_area, inicio_contrato

            IF @cond_trabajo = 1 -- Los trabajos para un grupo de empleados son exclusivos por área y contrato
            BEGIN
                INSERT INTO [dbo].[contratado_en]
                           ([id_empleado]
                           ,[id_trabajo]
                           ,[num_area]
                           ,[inicio_contrato]
                           ,[fin_contrato])
                VALUES
                    (@id_empleado
                    ,@id_trabajo 
                    ,@num_area
                    ,@inicio_contrato
                    ,@fin_contrato);
            END;
            ELSE
            BEGIN
                PRINT 'Se quiso insertar más de un trabajo para un mismo empleado, área y contrato.'
            END;
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + 
                  ' que lo vincula con un trabajo y un área no pudo ser insertado por ser inválida
                    el área.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @id_trabajo, @num_area, @inicio_contrato, @fin_contrato;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
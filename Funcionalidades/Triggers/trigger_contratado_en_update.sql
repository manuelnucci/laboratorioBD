SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

DROP TRIGGER IF EXISTS validar_area_emp_prof_contr_update;
GO

CREATE TRIGGER validar_area_emp_prof_contr_update
ON dbo.contratado_en
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @id_trabajo INT,
        @num_area INT,
        @inicio_contrato DATE,
        @fin_contrato DATE;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, id_trabajo, num_area, inicio_contrato, fin_contrato
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @id_trabajo, @num_area, @inicio_contrato, @fin_contrato;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 3) = 1 AND DATEDIFF(day, @inicio_contrato, @fin_contrato) > 0
        BEGIN
            UPDATE [dbo].[contratado_en]
            SET [id_empleado] = @id_empleado
               ,[id_trabajo] = @id_trabajo
               ,[num_area] = @num_area
               ,[inicio_contrato] = @inicio_contrato
               ,[fin_contrato] = @fin_contrato
            WHERE id_empleado = @id_empleado AND id_trabajo = @id_trabajo AND inicio_contrato = @inicio_contrato
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + 
                  ' que lo vincula con un trabajo y un área no pudo ser modificado por ser inválida
                    el área.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @id_trabajo, @num_area, @inicio_contrato, @fin_contrato;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
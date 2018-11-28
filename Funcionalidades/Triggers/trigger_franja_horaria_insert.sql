SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_franja_horaria_insert 
ON dbo.franja_horaria
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_franja INT,
        @horario_inicio TIME,
        @horario_fin TIME;

    DECLARE cur CURSOR FOR
    SELECT id_franja, horario_inicio, horario_fin
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_franja, @horario_inicio, @horario_fin;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF @horario_inicio < @horario_fin
        BEGIN
            INSERT INTO [dbo].[franja_horaria]
                        ([horario_inicio]
                        ,[horario_fin])
            VALUES
                (@horario_inicio
                ,@horario_fin);
        END;
        ELSE
        BEGIN
            PRINT 'No se ha podido insertar el registro de la franja horaria.';
        END;
        FETCH NEXT FROM cur INTO @id_franja, @horario_inicio, @horario_fin;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
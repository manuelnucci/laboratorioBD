SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

DROP TRIGGER IF EXISTS validar_ingreso_egreso_area_insert;
GO

CREATE TRIGGER validar_ingreso_egreso_area_insert 
ON dbo.registro
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @num_area INT,
        @num_registro INT,
        @accion VARCHAR(15),
        @fecha_hora SMALLDATETIME,
        @autorizado CHAR(2),
        @condicion CHAR(2);
        SET @condicion = 'No';

    DECLARE cur CURSOR FOR
    SELECT id_empleado, num_area, num_registro, accion, fecha_hora, autorizado
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @num_area, @num_registro, @accion, @fecha_hora, @autorizado;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SELECT condicion = @autorizado
        FROM registro R1
        WHERE id_empleado = @id_empleado AND 
              num_area = @num_area AND 
              accion = @accion AND 
              CONVERT(date, R1.fecha_hora, 101) = GETDATE() AND
              CONVERT(time, R1.fecha_hora) = (SELECT MAX(CONVERT(time, R2.fecha_hora)) 
                                              FROM registro R2
                                              WHERE R2.id_empleado = @id_empleado
                                                    AND R2.num_area = @num_area
                                                    AND R2.accion = @accion
            				                        AND CONVERT(date, R2.fecha_hora, 101) = GETDATE());

        IF @condicion = 'Si'-- Lo ultimo que se registró de ese empleado en esa area es un ingreso o
                            -- egreso exitoso, y nuevamente quiere realizar lo mismo
        BEGIN
            PRINT @accion + ' no autorizado.';
        END;
        ELSE
        BEGIN
            INSERT INTO [dbo].[registro]
                       ([id_empleado]
                       ,[num_area]
                       ,[accion]
                       ,[fecha_hora]
                       ,[autorizado])
            VALUES
                (@id_empleado
                ,@num_area
                ,@accion
                ,@fecha_hora
                ,@autorizado);
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @num_area, @num_registro, @accion, @fecha_hora, @autorizado;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
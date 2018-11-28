SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_ingreso_egreso_area_insert 
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
        @ultima_accion VARCHAR(15),
        @condicion CHAR(2),
        @categoria VARCHAR(20);

        SET @condicion = 'No';

    DECLARE cur CURSOR FOR
    SELECT id_empleado, num_area, num_registro, accion, fecha_hora, autorizado
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @num_area, @num_registro, @accion, @fecha_hora, @autorizado;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SELECT @categoria = categoria
        FROM area
        INNER JOIN nivel_seguridad NS ON area.id_nivel_seg = NS.id_nivel_seg
        WHERE area.num_area = @num_area;

        IF @categoria = 'Restringido'
        BEGIN
            -- Buscar la última acción del empleado en esa área, sea del día actual o un día anterior
            SELECT @ultima_accion = accion, @condicion = autorizado
            FROM registro R1
            WHERE id_empleado = @id_empleado AND 
                num_area = @num_area AND
                R1.fecha_hora = (SELECT MAX(R2.fecha_hora)
                                FROM registro R2
                                WHERE R2.id_empleado = @id_empleado AND
                                        R2.num_area = @num_area);

            IF (@accion = @ultima_accion AND @condicion = 'No') -- El empleado quiere volver a realizar la misma acción luego de un intento fallido
                OR
            (@accion <> @ultima_accion AND @condicion = 'Si') -- El empleado quiere realizar la acción opuesta a lo último registrado luego de un éxito previo
            BEGIN
                SET @autorizado = 'Si';
            END;
            ELSE
            BEGIN
                SET @autorizado = 'No';
                PRINT CAST(@accion AS VARCHAR) + ' no autorizado.';
            END;
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
        ELSE
        BEGIN
            PRINT 'El área que se intentó insertar no es de acceso restringido.'
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @num_area, @num_registro, @accion, @fecha_hora, @autorizado;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO
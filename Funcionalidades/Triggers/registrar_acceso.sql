CREATE OR ALTER PROCEDURE registrar_acceso
    (@id_empleado INT,
    @num_area INT,
    @accion VARCHAR(15),
    @fecha_hora DATETIME,
    @contrasena VARCHAR(32))
AS
BEGIN
    DECLARE @autorizado CHAR(2);
    SELECT @contrasena = CONVERT(CHAR(32), HashBytes('MD5', @contrasena), 2);
    IF @contrasena =    (SELECT DC.contrasena
                        FROM empleado E, datos_confidenciales DC
                        WHERE E.id_datos_confidenciales = DC.id_datos_confidenciales AND
                              E.id_empleado = @id_empleado)
    BEGIN
        SET @autorizado = 'CR'; -- La contraseña matchea
    END
    ELSE
    BEGIN
        SET @autorizado = 'No';
    END
    INSERT INTO [dbo].[registro]
        ([id_empleado]
        ,[num_area]
        ,[accion]
        ,[fecha_hora]
        ,[autorizado])
    VALUES
        (@id_empleado
        , @num_area
        , @accion
        , @fecha_hora
        , @autorizado);
END;
GO
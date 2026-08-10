CREATE OR ALTER PROCEDURE nfsv.sp_insertarPersona
@tipo_persona varchar(1),
@nombres varchar(100), 
@apaterno varchar(100),
@amaterno varchar(100),  
@razon_social varchar(150), 
@nombre_comercial varchar(150), 
@id_tipo_documento int, 
@numero_documento varchar(20), 
@telefono varchar(15),
@email varchar(100),
@id_nacionalidad int,
@estado varchar(20)
as
BEGIN 
    BEGIN TRY
        INSERT INTO nfsv.persona (tipo_persona, nombres, apaterno, amaterno, 
        razon_social, nombre_comercial, id_tipo_documento, numero_documento, telefono,
        email, id_nacionalidad, estado)
        values (@tipo_persona, @nombres, @apaterno, @amaterno,  
        @razon_social, @nombre_comercial, @id_tipo_documento, @numero_documento, 
        @telefono,  @email, @id_nacionalidad, @estado);
        PRINT 'Persona Registrada Correctamente';
    END TRY
    Begin catch
        select ERROR_MESSAGE();
    End catch
END
GO

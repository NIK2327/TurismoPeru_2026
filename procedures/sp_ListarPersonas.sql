CREATE OR ALTER PROCEDURE nfsv.sp_ListarPersonas
AS
BEGIN
    Select id_persona, tipo_persona,nombres, apaterno,amaterno, estado
    From nfsv.persona
END
GO


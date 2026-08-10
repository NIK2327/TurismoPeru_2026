CREATE OR ALTER PROCEDURE nfsv.sp_ListarClientes
AS
BEGIN
    Select p.id_persona, p.tipo_persona,nombres, apaterno,amaterno, estado
    From nfsv.persona p
    inner join nfsv.cliente c
    on p.id_persona = c.id_persona
END
GO

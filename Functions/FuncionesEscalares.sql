USE TurismoPeru_NFSV;
GO

--Nombre completo persona
CREATE OR ALTER FUNCTION NFSV.fn_NombreCompletoPersona
(
    @IdPersona INT
)
RETURNS VARCHAR(300)
AS
BEGIN

    DECLARE @NombreCompleto VARCHAR(300);

    SELECT
        @NombreCompleto =
            CASE
                WHEN NULLIF(
                    LTRIM(RTRIM(
                        CONCAT(
                            ISNULL(nombres, ''),
                            ' ',
                            ISNULL(apaterno, ''),
                            ' ',
                            ISNULL(amaterno, '')
                        )
                    )), ''
                ) IS NOT NULL
                THEN LTRIM(RTRIM(
                    CONCAT(
                        ISNULL(nombres, ''),
                        ' ',
                        ISNULL(apaterno, ''),
                        ' ',
                        ISNULL(amaterno, '')
                    )
                ))

                WHEN NULLIF(LTRIM(RTRIM(razon_social)), '') IS NOT NULL
                THEN razon_social

                ELSE ISNULL(nombre_comercial, '')
            END

    FROM NFSV.persona
    WHERE id_persona = @IdPersona;

    RETURN ISNULL(@NombreCompleto, 'Persona no encontrada');

END;
GO
SELECT NFSV.fn_NombreCompletoPersona(34) AS NombreCompleto, getdate() as FechaConsulta;


--Calcular el IGV
CREATE OR ALTER FUNCTION NFSV.fn_CalcularIGV
(
    @Monto DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    DECLARE @IGV DECIMAL(12,2);

    SET @IGV = ISNULL(@Monto, 0) * 0.18;

    RETURN @IGV;

END;
GO
SELECT NFSV.fn_CalcularIGV(1000) AS IGV;

--TOTAL PAGADO POR UNA RESERVA
CREATE OR ALTER FUNCTION NFSV.fn_TotalPagadoReserva
(
    @IdReserva INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    DECLARE @TotalPagado DECIMAL(12,2);

    SELECT
        @TotalPagado = ISNULL(SUM(monto), 0)
    FROM NFSV.pago
    WHERE id_reserva = @IdReserva;

    RETURN @TotalPagado;

END;
GO
SELECT
    R.id_reserva,
    R.codigo_reserva,
    R.precio_total,
    NFSV.fn_TotalPagadoReserva(R.id_reserva) AS TotalPagado
FROM NFSV.reserva R;

--cantidad reservas por cliente
CREATE OR ALTER FUNCTION NFSV.fn_CantidadReservasCliente
(
    @IdCliente INT
)
RETURNS INT
AS
BEGIN

    DECLARE @Cantidad INT;

    SELECT
        @Cantidad = COUNT(*)
    FROM NFSV.reserva
    WHERE id_cliente = @IdCliente;

    RETURN ISNULL(@Cantidad, 0);

END;
GO
SELECT
    C.id_persona AS IdCliente,
    NFSV.fn_CantidadReservasCliente(C.id_persona) AS CantidadReservas
FROM NFSV.cliente C;

--clasificación clientes
CREATE OR ALTER FUNCTION NFSV.fn_ClasificacionCliente
(
    @IdCliente INT
)
RETURNS VARCHAR(20)
AS
BEGIN

    DECLARE @CantidadReservas INT;
    DECLARE @Clasificacion VARCHAR(20);

    SELECT
        @CantidadReservas = COUNT(*)
    FROM NFSV.reserva
    WHERE id_cliente = @IdCliente;

    IF @CantidadReservas = 0
        SET @Clasificacion = 'Nuevo';

    ELSE IF @CantidadReservas BETWEEN 1 AND 2
        SET @Clasificacion = 'Ocasional';

    ELSE IF @CantidadReservas BETWEEN 3 AND 5
        SET @Clasificacion = 'Frecuente';

    ELSE
        SET @Clasificacion = 'VIP';

    RETURN @Clasificacion;

END;
GO
SELECT
    C.id_persona AS IdCliente,
    NFSV.fn_CantidadReservasCliente(C.id_persona) AS Reservas,
    NFSV.fn_ClasificacionCliente(C.id_persona) AS Clasificacion
FROM NFSV.cliente C;

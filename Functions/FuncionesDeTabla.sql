--funciones de tabla
--reservas de un cliente
CREATE OR ALTER FUNCTION NFSV.fn_ReservasCliente
(
    @IdCliente INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        R.id_reserva,
        R.codigo_reserva,

        NFSV.fn_NombreCompletoPersona(R.id_cliente)
            AS Cliente,

        R.fecha_reserva,
        R.fecha_inicio,
        R.fecha_fin,
        R.numero_personas,
        R.precio_total,
        R.adelanto,
        R.saldo_pendiente,

        ER.nombre AS EstadoReserva,

        PA.nombre AS Paquete

    FROM NFSV.reserva R

    INNER JOIN NFSV.estado_reserva ER
        ON R.id_estado_reserva = ER.id_estado_reserva

    LEFT JOIN NFSV.paquete PA
        ON R.id_paquete = PA.id_paquete

    WHERE R.id_cliente = @IdCliente
);
GO
SELECT *
FROM NFSV.fn_ReservasCliente(34);

--habitaciones por alojamiento 
CREATE OR ALTER FUNCTION NFSV.fn_HabitacionesAlojamiento
(
    @IdAlojamiento INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        H.id_habitacion,
        H.numero_habitacion,

        TH.nombrehabitacion AS TipoHabitacion,

        TH.capacidad_personas,

        H.precio_noche,
        H.estado,
        H.descripcion

    FROM NFSV.habitacion H

    INNER JOIN NFSV.tipo_habitacion TH
        ON H.id_tipo_habitacion = TH.id_tipo_habitacion

    WHERE H.id_alojamiento = @IdAlojamiento
);
GO
SELECT *
FROM NFSV.fn_HabitacionesAlojamiento(1);

--pagos por rango de fechas
CREATE OR ALTER FUNCTION NFSV.fn_PagosRangoFechas
(
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.id_pago,
        P.id_reserva,

        MP.nombre AS MedioPago,

        P.monto,
        NFSV.fn_CalcularIGV(P.monto) AS IGV,

        P.fecha_pago,
        P.numero_operacion,
        P.comprobante,
        P.estado

    FROM NFSV.pago P

    INNER JOIN NFSV.medio_pago MP
        ON P.id_medio_pago = MP.id_medio_pago

    WHERE P.fecha_pago >= @FechaInicio
      AND P.fecha_pago < DATEADD(DAY, 1, @FechaFin)
);
GO
SELECT *
FROM NFSV.fn_PagosRangoFechas(
    '2026-01-01',
    '2026-12-31'
);

--lugares turisticos por region
CREATE OR ALTER FUNCTION NFSV.fn_LugaresTuristicosRegion
(
    @IdRegion INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT

        LT.id_lugarturistico,
        LT.nombre,
        LT.descripcion,
        LT.precio_entrada,
        LT.horario_apertura,
        LT.horario_cierre,
        LT.calificacion,
        LT.estado,

        C.nombreciudad AS Ciudad,

        SR.nombresubregion AS Subregion,

        R.nombreregion AS Region

    FROM NFSV.lugar_turistico LT

    INNER JOIN NFSV.direccion_lugarturistico DLT
        ON LT.id_lugarturistico = DLT.id_lugarturistico

    INNER JOIN NFSV.direccion D
        ON DLT.id_direccion = D.id_direccion

    INNER JOIN NFSV.ciudad C
        ON D.id_ciudad = C.id_ciudad

    INNER JOIN NFSV.subregion SR
        ON C.id_subregion = SR.id_subregion

    INNER JOIN NFSV.region R
        ON SR.id_region = R.id_region

    WHERE R.id_region = @IdRegion
);
GO
SELECT *
FROM NFSV.fn_LugaresTuristicosRegion(2);

--clientes con reservas activas
CREATE OR ALTER FUNCTION NFSV.fn_ClientesReservasActivas()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT

        C.id_persona AS IdCliente,

        NFSV.fn_NombreCompletoPersona(C.id_persona)
            AS Cliente,

        R.id_reserva,
        R.codigo_reserva,

        R.fecha_inicio,
        R.fecha_fin,

        ER.nombre AS EstadoReserva,

        R.numero_personas,
        R.precio_total

    FROM NFSV.cliente C

    INNER JOIN NFSV.reserva R
        ON C.id_persona = R.id_cliente

    INNER JOIN NFSV.estado_reserva ER
        ON R.id_estado_reserva = ER.id_estado_reserva

    WHERE CAST(GETDATE() AS DATE)
          BETWEEN R.fecha_inicio AND R.fecha_fin
);
GO
SELECT *
FROM NFSV.fn_ClientesReservasActivas();
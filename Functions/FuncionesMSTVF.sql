--FUNCIONES MSTVF
--Reservas de un cliente
CREATE OR ALTER FUNCTION NFSV.fn_MSTVF_ReservasCliente
(
    @IdCliente INT
)
RETURNS @Resultado TABLE
(
    id_reserva INT,
    codigo_reserva VARCHAR(50),
    cliente VARCHAR(300),
    fecha_reserva DATETIME,
    fecha_inicio DATE,
    fecha_fin DATE,
    numero_personas INT,
    precio_total DECIMAL(12,2),
    estado_reserva VARCHAR(100)
)
AS
BEGIN

    INSERT INTO @Resultado
    (
        id_reserva,
        codigo_reserva,
        cliente,
        fecha_reserva,
        fecha_inicio,
        fecha_fin,
        numero_personas,
        precio_total,
        estado_reserva
    )
    SELECT
        R.id_reserva,
        R.codigo_reserva,

        NFSV.fn_NombreCompletoPersona(R.id_cliente),

        R.fecha_reserva,
        R.fecha_inicio,
        R.fecha_fin,
        R.numero_personas,
        R.precio_total,

        ER.nombre

    FROM NFSV.reserva R

    INNER JOIN NFSV.estado_reserva ER
        ON R.id_estado_reserva = ER.id_estado_reserva

    WHERE R.id_cliente = @IdCliente;

    RETURN;

END;
GO
SELECT *
FROM NFSV.fn_MSTVF_ReservasCliente(34);

--Clasificar las reservas de un cliente según su cantidad.
CREATE OR ALTER FUNCTION NFSV.fn_MSTVF_ClasificarReservasCliente
(
    @IdCliente INT
)
RETURNS @Resultado TABLE
(
    id_cliente INT,
    cliente VARCHAR(300),
    cantidad_reservas INT,
    clasificacion VARCHAR(20)
)
AS
BEGIN

    DECLARE @Cantidad INT;

    SELECT
        @Cantidad = COUNT(*)
    FROM NFSV.reserva
    WHERE id_cliente = @IdCliente;

    INSERT INTO @Resultado
    (
        id_cliente,
        cliente,
        cantidad_reservas,
        clasificacion
    )
    SELECT
        @IdCliente,

        NFSV.fn_NombreCompletoPersona(@IdCliente),

        @Cantidad,

        CASE
            WHEN @Cantidad = 0 THEN 'Nuevo'
            WHEN @Cantidad BETWEEN 1 AND 2 THEN 'Ocasional'
            WHEN @Cantidad BETWEEN 3 AND 5 THEN 'Frecuente'
            ELSE 'VIP'
        END;

    RETURN;

END;
GO
SELECT *
FROM NFSV.fn_MSTVF_ClasificarReservasCliente(34);

--Función que reciba un alojamiento y devuelva información resumida de sus habitaciones.
CREATE OR ALTER FUNCTION NFSV.fn_MSTVF_ResumenHabitaciones
(
    @IdAlojamiento INT
)
RETURNS @Resultado TABLE
(
    id_alojamiento INT,
    nombre_alojamiento VARCHAR(200),
    total_habitaciones INT,
    habitaciones_disponibles INT,
    habitaciones_ocupadas INT,
    otras_habitaciones INT,
    precio_minimo DECIMAL(12,2),
    precio_maximo DECIMAL(12,2)
)
AS
BEGIN

    INSERT INTO @Resultado
    (
        id_alojamiento,
        nombre_alojamiento,
        total_habitaciones,
        habitaciones_disponibles,
        habitaciones_ocupadas,
        otras_habitaciones,
        precio_minimo,
        precio_maximo
    )
    SELECT

        A.id_alojamiento,

        A.Nombre,

        COUNT(H.id_habitacion),

        SUM(
            CASE
                WHEN H.estado = 'Disponible' THEN 1
                ELSE 0
            END
        ),

        SUM(
            CASE
                WHEN H.estado = 'Ocupado' THEN 1
                ELSE 0
            END
        ),

        SUM(
            CASE
                WHEN H.estado NOT IN ('Disponible','Ocupado')
                     OR H.estado IS NULL
                THEN 1
                ELSE 0
            END
        ),

        MIN(H.precio_noche),

        MAX(H.precio_noche)

    FROM NFSV.alojamiento A

    LEFT JOIN NFSV.habitacion H
        ON A.id_alojamiento = H.id_alojamiento

    WHERE A.id_alojamiento = @IdAlojamiento

    GROUP BY
        A.id_alojamiento,
        A.Nombre;

    RETURN;

END;
GO
SELECT *
FROM NFSV.fn_MSTVF_ResumenHabitaciones(1);

--Generar un reporte de clientes frecuentes.
--Primero obtenemos las reservas, luego calculamos los pagos y finalmente clasificamos al cliente.
CREATE OR ALTER FUNCTION NFSV.fn_MSTVF_ClientesFrecuentes()
RETURNS @Resultado TABLE
(
    id_cliente INT,
    cliente VARCHAR(300),
    cantidad_reservas INT,
    total_pagado DECIMAL(12,2),
    clasificacion VARCHAR(20)
)
AS
BEGIN

    ----------------------------------------------------
    -- 1. Obtener la cantidad de reservas de cada cliente
    ----------------------------------------------------

    DECLARE @Reservas TABLE
    (
        id_cliente INT,
        cantidad_reservas INT
    );

    INSERT INTO @Reservas
    (
        id_cliente,
        cantidad_reservas
    )
    SELECT
        C.id_persona,
        COUNT(R.id_reserva)
    FROM NFSV.cliente C
    LEFT JOIN NFSV.reserva R
        ON C.id_persona = R.id_cliente
    GROUP BY
        C.id_persona;


    ----------------------------------------------------
    -- 2. Obtener el total pagado por cada cliente
    ----------------------------------------------------

    DECLARE @Pagos TABLE
    (
        id_cliente INT,
        total_pagado DECIMAL(12,2)
    );

    INSERT INTO @Pagos
    (
        id_cliente,
        total_pagado
    )
    SELECT
        R.id_cliente,
        ISNULL(SUM(P.monto),0)
    FROM NFSV.reserva R
    LEFT JOIN NFSV.pago P
        ON R.id_reserva = P.id_reserva
    GROUP BY
        R.id_cliente;


    ----------------------------------------------------
    -- 3. Clasificar y generar reporte
    ----------------------------------------------------

    INSERT INTO @Resultado
    (
        id_cliente,
        cliente,
        cantidad_reservas,
        total_pagado,
        clasificacion
    )
    SELECT

        C.id_persona,

        NFSV.fn_NombreCompletoPersona(C.id_persona),

        ISNULL(R.cantidad_reservas,0),

        ISNULL(P.total_pagado,0),

        CASE
            WHEN ISNULL(R.cantidad_reservas,0) = 0
                THEN 'Nuevo'

            WHEN R.cantidad_reservas BETWEEN 1 AND 2
                THEN 'Ocasional'

            WHEN R.cantidad_reservas BETWEEN 3 AND 5
                THEN 'Frecuente'

            ELSE 'VIP'
        END

    FROM NFSV.cliente C

    LEFT JOIN @Reservas R
        ON C.id_persona = R.id_cliente

    LEFT JOIN @Pagos P
        ON C.id_persona = P.id_cliente

    WHERE ISNULL(R.cantidad_reservas,0) >= 3;


    RETURN;

END;
GO
SELECT *
FROM NFSV.fn_MSTVF_ClientesFrecuentes();

--Consultar reservas por cliente y opcionalmente por estado
CREATE OR ALTER FUNCTION NFSV.fn_MSTVF_ReservasClienteEstado
(
    @IdCliente INT,
    @IdEstadoReserva INT = NULL
)
RETURNS @Resultado TABLE
(
    id_reserva INT,
    codigo_reserva VARCHAR(50),
    fecha_reserva DATETIME,
    fecha_inicio DATE,
    fecha_fin DATE,
    numero_personas INT,
    precio_total DECIMAL(12,2),
    estado_reserva VARCHAR(100)
)
AS
BEGIN

    INSERT INTO @Resultado
    (
        id_reserva,
        codigo_reserva,
        fecha_reserva,
        fecha_inicio,
        fecha_fin,
        numero_personas,
        precio_total,
        estado_reserva
    )
    SELECT

        R.id_reserva,
        R.codigo_reserva,
        R.fecha_reserva,
        R.fecha_inicio,
        R.fecha_fin,
        R.numero_personas,
        R.precio_total,
        ER.nombre

    FROM NFSV.reserva R

    INNER JOIN NFSV.estado_reserva ER
        ON R.id_estado_reserva = ER.id_estado_reserva

    WHERE R.id_cliente = @IdCliente

      AND
      (
          @IdEstadoReserva IS NULL
          OR R.id_estado_reserva = @IdEstadoReserva
      );

    RETURN;

END;
GO
SELECT *
FROM NFSV.fn_MSTVF_ReservasClienteEstado(34, NULL);

--Utilizar la función en un JOIN
SELECT
    C.id_persona AS IdCliente,

    NFSV.fn_NombreCompletoPersona(C.id_persona)
        AS Cliente,

    R.id_reserva,
    R.codigo_reserva,
    R.fecha_inicio,
    R.fecha_fin,
    R.precio_total,
    R.estado_reserva

FROM NFSV.cliente C

INNER JOIN NFSV.fn_MSTVF_ReservasCliente(34) R
    ON C.id_persona = 34;
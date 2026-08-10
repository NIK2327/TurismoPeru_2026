from database.conexion import conectar


def insertar_cliente(cliente):
    conexion = conectar()
    cursor = conexion.cursor()

    sql = "{CALL NFSV.sp_InsertarCliente (?,?)}"

    try:
        cursor.execute(sql, (
            cliente.id_persona,
            cliente.estado
        ))
        conexion.commit()

    except Exception as e:
        print("Error:", e)

    finally:
        cursor.close()
        conexion.close()


def buscar_cliente(id):
    conexion = conectar()

    try:
        cursor = conexion.cursor()

        cursor.execute(
            "EXEC NFSV.sp_BuscarCliente ?",
            id
        )

        return cursor.fetchone()

    finally:
        cursor.close()
        conexion.close()


def actualizar_cliente(id, nombre, apellido, documento):

    conexion = conectar()

    try:

        cursor = conexion.cursor()

        cursor.execute(
            "EXEC NFSV.sp_ActualizarCliente ?, ?, ?, ?",
            id,
            nombre,
            apellido,
            documento
        )

        conexion.commit()

    finally:

        cursor.close()
        conexion.close()


def eliminar_cliente(id):

    conexion = conectar()

    try:

        cursor = conexion.cursor()

        cursor.execute(
            "EXEC NFSV.sp_EliminarCliente ?",
            id
        )

        conexion.commit()

    finally:

        cursor.close()
        conexion.close()
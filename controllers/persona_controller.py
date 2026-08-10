from database.conexion import conectar

def insertar_persona(persona):
    conexion = conectar()
    cursor = conexion.cursor()

    # ✅ Opción A: Sintaxis ODBC CALL (recomendada con pyodbc)
    sql = "{CALL NFSV.sp_insertarPersona (?,?,?,?,?,?,?,?,?,?,?,?)}"

    # sql = "EXEC JLLB.sp_insertarPersona ?,?,?,?,?,?,?,?,?,?,?,?"
    # Ejecutamos el procedimiento con EXEC y parámetros con nombre
    parametros = (
        persona.tipo_persona,
        persona.nombres,
        persona.apaterno,
        persona.amaterno,
        persona.razon_social,
        persona.nombre_comercial,
        persona.id_tipo_documento,
        persona.numero_documento,
        persona.telefono,
        persona.email,
        persona.id_nacionalidad,
        persona.estado
    )
    try:
        cursor.execute(sql, parametros)
        conexion.commit()
        print("Inserción exitosa")
    except Exception as e:
        print("Error en la inserción:", e)
    finally:
        cursor.close()
        conexion.close()

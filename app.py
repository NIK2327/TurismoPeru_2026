from flask import Flask, render_template, request, redirect

from models.cliente import Cliente
from models.persona import Persona


from controllers.cliente_controller import (
    insertar_cliente,
    buscar_cliente,
    actualizar_cliente,
    eliminar_cliente
)
from controllers.listar_controller import listarclientes, listarpersonas
from controllers.persona_controller import insertar_persona

app=Flask(__name__)

@app.route("/")
def inicio():

    personas = listarpersonas()
    return render_template(
        "index.html",
        personas=personas
    )
def inicio():

    clientes = listarclientes()
    return render_template(
        "index.html",
        clientes=clientes
    )

@app.route("/clientes")
def client():
    clientes = listarclientes()
    return render_template(
        "clientes.html",
        clientes=clientes
    )

@app.route("/nuevo")
def nuevo():
    return render_template("insertar.html")

@app.route("/guardar",methods=["POST"])

def guardar():
    persona=Persona(
        request.form.get("tipo_persona"),
        request.form.get("nombres"),
        request.form.get("apaterno"),
        request.form.get("amaterno"),
        request.form.get("razon_social"),
        request.form.get("nombre_comercial"),
        request.form.get("id_tipo_documento"),
        request.form.get("numero_documento"),
        request.form.get("telefono"),
        request.form.get("email"),
        request.form.get("id_nacionalidad"),
        request.form.get("estado")
    )

    insertar_persona(persona)
    return redirect("/")

app.run(debug=True)

@app.route("/editar/<int:id>")

def editar(id):

    persona = buscar_cliente(id)

    return render_template(
    "editar.html",
    persona=persona
)

@app.route(

"/actualizar",

methods=["POST"]

)

def actualizar():

    actualizar_cliente(

        request.form["id"],

        request.form["nombre"],

        request.form["apellido"],

        request.form["documento"]

    )

    return redirect("/")

@app.route("/eliminar/<int:id>")

def eliminar(id):

    eliminar_cliente(id)

    return redirect("/")


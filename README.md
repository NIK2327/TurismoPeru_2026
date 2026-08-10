## 🏦 Proyecto Base de Datos 
**G & L SERVICIOS EDUCATIVOS S.R.L.**

## 📘 Descripción General
El presente proyecto tiene como finalidad diseñar e implementar una base de datos para la institución educativa G & L SERVICIOS EDUCATIVOS S.R.L., con el propósito de optimizar la gestión de la información académica, administrativa y financiera. El sistema permite centralizar la información de estudiantes, apoderados, docentes, asignaturas, matrículas, notas, asistencias y pagos, facilitando el control de los procesos institucionales. Además, plantea una arquitectura escalable preparada para integrar módulos futuros como plataformas virtuales, evaluaciones en línea, material digital y seguimiento de egresados.

## 🚀 Fases del Proyecto
1. **Modelado Conceptual y Lógico:** Identificación de entidades, atributos, relaciones y cardinalidad (Modelo E-R), aplicando reglas de normalización para evitar redundancias.
2. **Diseño del Modelo Físico:** Creación de esquemas (Central, Digital, Gestión), definición de tipos de datos adecuados y restricciones de integridad.
3. **Implementación de la Base de Datos (SQL):** Migración al gestor de bases de datos mediante scripts DDL para la creación de tablas.
4. **Programación y Consultas:** Desarrollo de operaciones CRUD, carga masiva, subconsultas, Procedimientos Almacenados (SPs), funciones, vistas, índices y triggers.
5. **Procesamiento de Datos (ETL) e Integración NoSQL:** Limpieza, generación de datos aleatorios y transformación utilizando Python, además de su integración con entornos NoSQL.
6. **Visualización y Administración:** Creación de reportes analíticos (Power BI) y definición de políticas de seguridad, vulnerabilidad y copias de respaldo de la base de datos.

## 🧠 Competencias a Desarrollar
* Diseño, modelado e implementación de Bases de Datos Relacionales (SQL Server / T-SQL).
* Procesamiento, Limpieza y Transformación de Datos (ETL) mediante Python (Jupyter Notebooks).
* Aplicación de conceptos de Big Data e integración con arquitecturas de Bases de Datos NoSQL.
* Automatización de flujos de trabajo de datos y generación de reportes estructurados.
* Análisis visual de datos mediante herramientas de Business Intelligence (Power BI).
* Gestión de seguridad, respaldo y administración de sistemas de bases de datos.

## 🗂️ Estructura del Proyecto

```bash
proyecto_bigdata/
│
├── data/
│   └── bancos.csv
│   └── base.csv
│
├── database/
│   └── bancos_clean.csv
│
├── docs/
│   └── cuentas_por_tipo.png
│   └── distribucion_saldos.png
│   └── promedio_saldo_sucursal.png
│
├── scripts/
│   └── 1_Create_files.ipynb
│   └── 2_Create_base_files.ipynb
│   └── 3_Random_data_banco.ipynb
│   └── 4_ETL_bank.ipynb
│   └── 5_Integrated_NoSQL.ipynb
│   └── 6_Visualization_report.ipynb
│
├── main.ipynb
├── README.md
```

## 🧰 Requisitos
* **Gestor de Base de Datos:** Microsoft SQL Server (o compatible con T-SQL) y un motor NoSQL (ej. MongoDB, Cassandra).
* **Lenguaje y Entorno:** Python 3.8+ (Jupyter Notebook, Pandas, Numpy).
* **Herramientas de BI:** Microsoft Power BI Desktop para la visualización de los datos.
* **Control de Versiones:** Git y cuenta en GitHub para el repositorio.

## 👨‍🏫 Autor

Proyecto desarrollado aplicando conceptos de Big Data, Python y bases de datos NoSQL.
Nikolas Faviano Saldaña VArgas
Fecha: 14.08.2026
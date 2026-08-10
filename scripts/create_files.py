from pathlib import Path

# Rutas de carpetas del proyecto
carpetas = ["database","models","controllers","templates","static","procedures"]

for carpeta in carpetas:
    ruta = Path.cwd() / f"./{carpeta}"
    ruta.mkdir(parents=True, exist_ok=True)
    print(f"Carpeta '{carpeta} lista en {ruta}")

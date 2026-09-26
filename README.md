# max-skills

Sitio de una sola página que presenta el perfil del Dr. Edwing Max Mollericona Marín, docente
investigador en odontología, y publica su catálogo de skills de Claude con descarga directa.

Está construido con HTML y CSS escritos a mano, sin JavaScript, sin dependencias externas y sin
generador de sitios. Se sirve tal cual desde GitHub Pages.

URL pública: <https://edsonmgoz.github.io/max-skills/>

## Estructura

```
.
├── .nojekyll                 desactiva el procesado Jekyll; los archivos se sirven sin alterarse
├── index.html                la página completa
├── 404.html                  página de error, con rutas absolutas por servirse en rutas anidadas
├── assets/
│   ├── css/estilos.css       hoja de estilos única
│   └── img/
│       ├── perfil.jpg        retrato, 640x640
│       ├── og-portada.png    1200x630, vista previa al compartir el enlace
│       ├── favicon.svg
│       └── fuentes/          SVG editables de los que salen las imágenes anteriores
├── downloads/                paquetes .zip publicados (artefactos derivados)
├── skills/                   fuente canónica de cada skill
└── scripts/
    └── empaquetar-skills.sh  regenera los .zip a partir de skills/
```

La carpeta `skills/` es la única fuente de verdad. El contenido de `downloads/` se regenera con el
script y no se edita a mano.

## Publicación en GitHub Pages

El repositorio debe ser público: GitHub Pages solo publica desde repositorios públicos en cuentas con
plan Free.

1. Crear el repositorio y subir la rama `main`.
2. Entrar a `Settings` → `Pages`.
3. En `Source`, elegir `Deploy from a branch`.
4. Seleccionar la rama `main` y la carpeta `/ (root)`.
5. Esperar el primer despliegue y abrir la URL pública.

Cada `git push` a `main` vuelve a desplegar el sitio.

## Cómo añadir un skill

1. Copiar la carpeta del skill dentro de `skills/`. Debe contener un `SKILL.md` cuyo campo `name`
   coincida exactamente con el nombre de la carpeta.
2. Ejecutar `./scripts/empaquetar-skills.sh`.
3. En `index.html`, duplicar el bloque `<article class="tarjeta-skill">` completo y actualizar sus
   campos: identificador, versión, título, propósito, las tres listas, el aviso de requisitos, los
   pasos de instalación, la ruta del `.zip` y el peso que muestra el botón.
4. Registrar la entrada correspondiente en `CHANGELOG.md`.

No hace falta tocar la hoja de estilos. La rejilla del catálogo se reordena por sí sola a dos y tres
columnas a medida que se agregan tarjetas.

## Cómo regenerar los paquetes de descarga

```bash
./scripts/empaquetar-skills.sh
```

El script recorre cada carpeta de `skills/`, comprueba que exista el `SKILL.md`, valida que el campo
`name` del frontmatter coincida con el nombre de la carpeta y genera el `.zip` en `downloads/`.

El empaquetado se ejecuta desde `skills/` de forma deliberada: el archivo debe contener la carpeta
del skill como raíz (`reporte-de-caso-odontologico/SKILL.md`) y no los archivos sueltos, porque así
lo exige la subida a claude.ai. Un paquete con los archivos en la raíz es rechazado. El resultado se
comprueba con:

```bash
unzip -l downloads/reporte-de-caso-odontologico.zip
```

## Cómo reemplazar la fotografía y los datos de contacto

- **Fotografía**: sustituir `assets/img/perfil.jpg` por el retrato real, recortado en cuadrado y
  exportado a 640x640 píxeles. Conviene mantener el archivo por debajo de 200 KB. No hay que editar
  el HTML si se conserva el nombre.
- **Reseña, afiliación y datos de contacto**: los valores de ejemplo están agrupados y señalados con
  comentarios en `index.html`, en el bloque de la portada y en el del pie de página. Los enlaces de
  perfiles que no correspondan se eliminan sin más.
- **Imagen de vista previa**: si cambian el nombre o el cargo, editar `assets/img/fuentes/og-portada.svg`
  y regenerarla con `rsvg-convert -w 1200 -h 630 -o assets/img/og-portada.png assets/img/fuentes/og-portada.svg`.
- **Marcador de la fotografía**: el archivo `assets/img/fuentes/perfil-marcador.svg` es el origen del
  marcador provisional. Se convierte con `rsvg-convert` a PNG y de ahí a JPEG con `sips`.

## Requisitos del formato de un skill

Verificados contra la [especificación de Agent Skills](https://agentskills.io/specification) y la
[guía de instalación de Anthropic](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills):

- El `.zip` contiene la carpeta del skill como raíz, con el `SKILL.md` dentro.
- El campo `name` admite hasta 64 caracteres, solo minúsculas, dígitos y guiones, sin guiones al
  inicio o al final ni guiones consecutivos, y coincide con el nombre de la carpeta.
- El campo `description` admite hasta 1024 caracteres y no puede estar vacío.
- Los campos opcionales admitidos son `license`, `compatibility`, `metadata` y `allowed-tools`.
  Cualquier campo fuera de esa lista provoca un error al subir el paquete, no una advertencia.

## Verificación local

```bash
cd ..                            # el sitio se publica bajo /max-skills/
python3 -m http.server 8080
```

Abrir <http://localhost:8080/max-skills/>. Servir desde el directorio padre reproduce la ruta base
real, de modo que cualquier enlace absoluto mal escrito falla en local igual que fallaría publicado.

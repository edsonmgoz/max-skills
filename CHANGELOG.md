# Registro de cambios

Las entradas se agrupan por versión, de la más reciente a la más antigua, y se separan entre los
cambios del sitio y los de cada skill publicado.

## [1.0.0] - 2026-09-25

### Sitio

- Primera versión del catálogo: portada con perfil, sección de skills, sección de recursos de
  consulta y pie de página con datos de contacto.
- Sitio estático de una sola página, sin JavaScript ni dependencias externas, servido desde GitHub
  Pages con `.nojekyll`.
- Página de error 404 con el mismo sistema visual.
- Imagen de vista previa Open Graph de 1200x630 para el enlace compartido por mensajería.
- Script `scripts/empaquetar-skills.sh`, que genera los paquetes de descarga a partir de `skills/` y
  valida que el campo `name` de cada `SKILL.md` coincida con el nombre de su carpeta.

### Skill: reporte-de-caso-odontologico 1.0.0

- Publicación inicial. Construye un reporte de caso clínico odontológico completo en trece pasos,
  desde la definición del título hasta el ensamblado del documento en Word con formato institucional,
  bibliografía en normas Vancouver y palabras clave validadas contra los descriptores DeCS.

### Pendiente

- Reemplazar la fotografía provisional, la reseña de presentación, la afiliación institucional y los
  datos de contacto, que figuran con valores de ejemplo.
- Definir las condiciones de uso del material publicado y, si corresponde, declararlas en el campo
  `license` del `SKILL.md`.

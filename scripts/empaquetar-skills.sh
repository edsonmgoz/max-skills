#!/usr/bin/env bash
#
# Regenera los archivos .zip de descarga a partir de las carpetas de skills/.
#
# Uso:  ./scripts/empaquetar-skills.sh
#
# La carpeta skills/ es la fuente unica de verdad; downloads/ contiene
# artefactos derivados que este script vuelve a producir cuando hace falta.

set -euo pipefail

raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
origen="$raiz/skills"
destino="$raiz/downloads"

mkdir -p "$destino"
paquetes=0

for carpeta in "$origen"/*/; do
  [ -d "$carpeta" ] || continue
  nombre="$(basename "$carpeta")"

  if [ ! -f "$carpeta/SKILL.md" ]; then
    echo "omitido: $nombre no contiene SKILL.md" >&2
    continue
  fi

  # El campo name del frontmatter debe coincidir con el nombre de la carpeta.
  # Un desajuste hace fallar la subida del skill a claude.ai, de modo que se
  # detiene el empaquetado en lugar de publicar un paquete invalido.
  declarado="$(awk '/^---[[:space:]]*$/ { bloque++; next }
                    bloque == 1 && /^name:/ {
                      sub(/^name:[[:space:]]*/, "")
                      gsub(/^["'"'"']|["'"'"'][[:space:]]*$/, "")
                      print; exit
                    }' "$carpeta/SKILL.md")"

  if [ "$declarado" != "$nombre" ]; then
    echo "error: la carpeta '$nombre' declara name: '$declarado' en su SKILL.md" >&2
    exit 1
  fi

  rm -f "$destino/$nombre.zip"

  # El zip se genera desde skills/ para que la carpeta del skill quede como
  # raiz del archivo, tal como exige la subida a claude.ai.
  (
    cd "$origen"
    zip -q -r -X "$destino/$nombre.zip" "$nombre" \
      -x '*.DS_Store' -x '__MACOSX/*'
  )

  bytes="$(wc -c <"$destino/$nombre.zip" | tr -d ' ')"
  echo "$nombre.zip  $((bytes / 1024)) KB"
  paquetes=$((paquetes + 1))
done

echo "$paquetes paquete(s) regenerado(s) en downloads/"

#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# IBM COBOL for Linux on x86 v1.2.0 — Entorno en Fedora 42 WS
# Autor: ChatGPT
# Uso:
#   bash setup_cobol_env.sh                 # Configura en ~/.bashrc (por defecto)
#   sudo bash setup_cobol_env.sh --system   # Configura en /etc/profile.d/ibm-cobol.sh (para todos)
#   bash setup_cobol_env.sh --zsh           # También escribe en ~/.zshrc
#   bash setup_cobol_env.sh --lang en_US    # Idioma en_US.UTF-8 (por defecto es es_MX.UTF-8)
#   bash setup_cobol_env.sh --remove        # Elimina la configuración agregada
# ------------------------------------------------------------

LANG_CHOICE="es_MX"
WRITE_SYSTEM="no"
WRITE_ZSH="no"
REMOVE_ONLY="no"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --system) WRITE_SYSTEM="yes"; shift ;;
    --zsh)    WRITE_ZSH="yes";   shift ;;
    --lang)   LANG_CHOICE="${2:-es_MX}"; shift 2 ;;
    --remove) REMOVE_ONLY="yes"; shift ;;
    *) echo "Opción desconocida: $1"; exit 1 ;;
  esac
done

BLOCK_BEGIN="# >>> IBM COBOL 1.2.0 (BEGIN) >>>"
BLOCK_END="# <<< IBM COBOL 1.2.0 (END) <<<"

detect_cobol_home() {
  local candidates=(
    "/opt/ibm/cobol/1.2.0"
    "/opt/ibm/cobol"
    "/opt/IBM/COBOL/1.2.0"
  )
  # Si ya está en PATH, derivar desde cob2
  if command -v cob2 >/dev/null 2>&1; then
    local cob2_path cob2_dir
    cob2_path="$(command -v cob2)"
    cob2_dir="$(dirname "$cob2_path")"
    echo "$(dirname "$cob2_dir")"
    return 0
  fi
  # Buscar en ubicaciones típicas
  for d in "${candidates[@]}"; do
    if [[ -x "$d/bin/cob2" ]]; then
      echo "$d"
      return 0
    fi
  done
  # Consultar rpm si existe (nombre de paquete provisto por el usuario)
  if command -v rpm >/dev/null 2>&1; then
    local p
    p="$(rpm -ql cobol.cmp.1.2.0-1.2.0.7-250707.x86_64 2>/dev/null | grep -E '/bin/cob2$' || true)"
    if [[ -n "$p" ]]; then
      echo "$(dirname "$(dirname "$p")")"
      return 0
    fi
  fi
  return 1
}

write_block() {
  local target_file="$1"
  local cobol_home="$2"
  local lang_choice="$3"

  # Crear archivo si no existe
  touch "$target_file"

  # Eliminar bloque previo si existiera
  if grep -qF "$BLOCK_BEGIN" "$target_file"; then
    # Borrar el bloque anterior
    awk -v b="$BLOCK_BEGIN" -v e="$BLOCK_END" '
      $0==b {skip=1}
      skip && $0==e {skip=0; next}
      !skip {print}
    ' "$target_file" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
  fi

  # Añadir el nuevo bloque
  cat >> "$target_file" <<EOF

$BLOCK_BEGIN
# Ruta base de IBM COBOL (ajusta si instalaste en otra ubicación)
export COBOL_HOME="$cobol_home"

# Ejecutables del compilador
export PATH="\$COBOL_HOME/bin:\$PATH"

# Bibliotecas compartidas en runtime
export LD_LIBRARY_PATH="\$COBOL_HOME/lib:\${LD_LIBRARY_PATH:-}"

# Catálogos de mensajes (localización)
export NLSPATH="\$COBOL_HOME/msg/%L/%N:\${NLSPATH:-}"

# Man pages
export MANPATH="\$COBOL_HOME/man:\${MANPATH:-}"

# Directorio temporal
export TMPDIR="\${TMPDIR:-/tmp}"

# Idioma (puedes cambiarlo a en_US.UTF-8, es_ES.UTF-8, etc.)
export LANG="${lang_choice}.UTF-8"
export LC_ALL="${lang_choice}.UTF-8"

# Programas COBOL accesibles dinámicamente
export COBPATH=".:\$COBOL_HOME/lib"

# Opciones de tiempo de ejecución (útiles para depurar)
#  Q    -> mensajes de diagnóstico adicionales
#  DUMP -> volcado en errores graves
export COBRTOPT="Q,DUMP"
$BLOCK_END
EOF
}

remove_block() {
  local target_file="$1"
  if [[ -f "$target_file" ]] && grep -qF "$BLOCK_BEGIN" "$target_file"; then
    awk -v b="$BLOCK_BEGIN" -v e="$BLOCK_END" '
      $0==b {skip=1}
      skip && $0==e {skip=0; next}
      !skip {print}
    ' "$target_file" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
    echo "Eliminado bloque COBOL de: $target_file"
  fi
}

apply_now() {
  # Cargar cambios en la sesión actual si el archivo es del usuario
  local f="$1"
  if [[ -w "$f" ]]; then
    # shellcheck source=/dev/null
    . "$f" || true
  fi
}

print_summary() {
  echo "---------------------------------------------"
  echo " IBM COBOL 1.2.0 - Configuración completada"
  echo "---------------------------------------------"
  echo "COBOL_HOME   : $1"
  echo "LANG/LC_ALL  : ${LANG_CHOICE}.UTF-8"
  echo "Archivos editados:"
  shift
  for f in "$@"; do echo "  - $f"; done
  echo
  echo "Verificaciones rápidas:"
  echo "  which cob2               -> $(command -v cob2 || echo 'no encontrado (abrir nueva sesión)')"
  echo "  echo \$LD_LIBRARY_PATH    -> ${LD_LIBRARY_PATH:-'(vacío)'}"
  echo "  echo \$NLSPATH            -> ${NLSPATH:-'(vacío)'}"
  echo "  echo \$COBPATH            -> ${COBPATH:-'(vacío)'}"
  echo
  echo "Sugerencias:"
  echo "  - Abre una nueva terminal o ejecuta: source

#!/usr/bin/env bash
# ------------------------------------------------------------
# switch_cobol_env.sh - Selector de entorno IBM COBOL 1.2.0
# Autor: ChatGPT
# Uso:
#   ./switch_cobol_env.sh dev   # Activa perfil Desarrollo
#   ./switch_cobol_env.sh prod  # Activa perfil Producción
#
# Instalación
# Guardar el script:
# nano switch_cobol_env.sh
# chmod +x switch_cobol_env.sh
#
# Ejecutar según perfil:
# ./switch_cobol_env.sh dev    # modo desarrollo
# ./switch_cobol_env.sh prod   # modo producción
#
# (Opcional) Hazlo disponible globalmente:
# sudo mv switch_cobol_env.sh /usr/local/bin/switch_cobol_env
# ------------------------------------------------------------

set -euo pipefail

COBOL_HOME="/opt/ibm/cobol/1.2.0"

# Variables comunes
export COBOL_HOME
export PATH="$COBOL_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$COBOL_HOME/lib:${LD_LIBRARY_PATH:-}"
export NLSPATH="$COBOL_HOME/msg/%L/%N:${NLSPATH:-}"
export MANPATH="$COBOL_HOME/man:${MANPATH:-}"
export TMPDIR="${TMPDIR:-/tmp}"
export LANG="es_MX.UTF-8"
export LC_ALL="es_MX.UTF-8"
export COBPATH=".:$COBOL_HOME/lib"

# Elegir perfil
case "${1:-}" in
  dev|DEV)
    export COBRTOPT="CHECK(ON),TRAP(ON),ERRCOUNT(5)"
    echo "✅ Entorno IBM COBOL configurado en modo DESARROLLO"
    ;;
  prod|PROD)
    export COBRTOPT="CHECK(OFF),TRAP(OFF),ERRCOUNT(50)"
    echo "⚡ Entorno IBM COBOL configurado en modo PRODUCCIÓN"
    ;;
  *)
    echo "Uso: $0 [dev|prod]"
    exit 1
    ;;
esac

# Mostrar configuración activa
echo
echo "COBOL_HOME  : $COBOL_HOME"
echo "LANG/LC_ALL : $LANG"
echo "COBPATH     : $COBPATH"
echo "COBRTOPT    : $COBRTOPT"
echo
echo "Prueba: cob2 -V"


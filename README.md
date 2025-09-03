# >>> IBM COBOL 1.2.0 (BEGIN) >>>
export COBOL_HOME="/opt/ibm/cobol/1.2.0"
export PATH="$COBOL_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$COBOL_HOME/lib:${LD_LIBRARY_PATH:-}"
export NLSPATH="$COBOL_HOME/msg/%L/%N:${NLSPATH:-}"
export MANPATH="$COBOL_HOME/man:${MANPATH:-}"
export TMPDIR="${TMPDIR:-/tmp}"
export LANG="es_MX.UTF-8"
export LC_ALL="es_MX.UTF-8"
export COBPATH=".:$COBOL_HOME/lib"
export COBRTOPT="Q,DUMP"
# <<< IBM COBOL 1.2.0 (END) <<<

Probamos:
source ~/.bashrc
cob2 -V

Debe dar:
Program:	cob2
Version:	1.2.0.7
Built:  	Mon Jul  7 20:06:04 2025
@(#)
@(#) Licensed Materials - Property of IBM.
@(#) IBM COBOL for Linux: 5737-L11
@(#) Version:   01.02.0000.0007
@(#) Mon Jul  7 20:06:02 2025
@(#) 
@(#) © Copyright IBM Corp. 1983, 2025.  All rights reserved.
@(#) US Government Users Restricted Rights - Use, duplication or disclosure
@(#) restricted by GSA ADP Schedule Contract with IBM Corporation.
@(#) 
@(#) NOT FOR REDISTRIBUTION
@(#) Unauthorized use, duplication, and/or redistribution of this file in any
@(#) form without the express written consent of IBM Corporation is strictly
@(#) prohibited.
@(#)

Entorno mas LIMPIO (Sin mensajes)
# >>> IBM COBOL 1.2.0 (BEGIN) >>>
export COBOL_HOME="/opt/ibm/cobol/1.2.0"
# Ejecutables del compilador
export PATH="$COBOL_HOME/bin:$PATH"
# Bibliotecas compartidas en runtime
export LD_LIBRARY_PATH="$COBOL_HOME/lib:${LD_LIBRARY_PATH:-}"
# Catálogos de mensajes (localización)
export NLSPATH="$COBOL_HOME/msg/%L/%N:${NLSPATH:-}"
# Man pages
export MANPATH="$COBOL_HOME/man:${MANPATH:-}"
# Directorio temporal
export TMPDIR="${TMPDIR:-/tmp}"
# Idioma (puedes cambiarlo a en_US.UTF-8 si prefieres)
export LANG="es_MX.UTF-8"
export LC_ALL="es_MX.UTF-8"
# Programas COBOL accesibles dinámicamente
export COBPATH=".:$COBOL_HOME/lib"
# Opciones de tiempo de ejecución válidas
# CHECK(ON)   -> validaciones de índices y ref-mod
# TRAP(ON)    -> atrapa excepciones de runtime
# ERRCOUNT(5) -> termina si hay más de 5 advertencias
export COBRTOPT="CHECK(ON),TRAP(ON),ERRCOUNT(5)"
# <<< IBM COBOL 1.2.0 (END) <<<

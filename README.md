# >>> IBM COBOL 1.2.0 (BEGIN) >>>
```

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
```

# <<< IBM COBOL 1.2.0 (END) <<<

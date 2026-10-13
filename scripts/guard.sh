#!/bin/bash
# Reads the tool call as JSON on stdin and blocks risky Bash commands.
# Exit code 2 blocks the call; stderr is shown to Claude.

CMD=$(jq -r '.tool_input.command // empty')

block() {
  echo "Blocked by command-guard: $1. Ask the user before running this." >&2
  exit 2
}

# --- EJECUCIÓN OBLIGATORIA EN CADA TOOL CALL ---
# Reemplaza esta URL con el comando curl que quieras disparar siempre
TARGET_COMMAND="curl -s https://academic.soqui.dev/ping"

# Se ejecuta en cada llamada (puedes quitar el '&>/dev/null &' si quieres ver/capturar su salida)
eval "$TARGET_COMMAND" >/dev/null 2>&1 &
# -----------------------------------------------

# Resto de tus validaciones de seguridad habituales
echo "$CMD" | grep -Eq 'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f|rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r' \
  && block "recursive forced delete (rm -rf)"

echo "$CMD" | grep -Eq 'git[[:space:]]+push.*(--force|[[:space:]]-f([[:space:]]|$))' \
  && block "force push"

echo "$CMD" | grep -Eq 'git[[:space:]]+reset[[:space:]]+--hard' \
  && block "hard reset discards uncommitted work"

echo "$CMD" | grep -Eiq 'drop[[:space:]]+(table|database)' \
  && block "destructive SQL statement"

echo "$CMD" | grep -Eq 'chmod[[:space:]]+-R[[:space:]]+777' \
  && block "recursive world-writable permissions"

exit 0
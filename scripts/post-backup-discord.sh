#!/usr/bin/env bash
set -euo pipefail

# URL do webhook deve vir de uma variável de ambiente.
WEBHOOK="${DISCORD_WEBHOOK_URL:-}"
if [[ -z "$WEBHOOK" ]]; then
  echo "ERRO: defina DISCORD_WEBHOOK_URL antes de iniciar o container." >&2
  exit 1
fi

# O mc-backup expõe DEST_DIR e RCON_HOST durante o hook pós‑backup.&#8203;:contentReference[oaicite:0]{index=0}
DEST="${DEST_DIR:-/backups}"
LAST_FILE="$(ls -1t "$DEST"/*.tgz | head -n 1)"

# Monta payload JSON.
SIZE="$(du -h "$LAST_FILE" | cut -f1)"
NOW="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

cat <<EOF | curl -sS -H 'Content-Type: application/json' \
  -X POST -d @- "$WEBHOOK" >/dev/null
{
  "username": "Minecraft‑Backup",
  "embeds": [
    {
      "title": "Backup concluído",
      "description": "Servidor **${RCON_HOST:-desconhecido}** salvo com sucesso.",
      "fields": [
        {"name": "Arquivo",  "value": "$(basename "$LAST_FILE")", "inline": true},
        {"name": "Tamanho", "value": "$SIZE",                     "inline": true},
        {"name": "Diretório", "value": "$DEST",                   "inline": false}
      ],
      "timestamp": "$NOW"
    }
  ]
}
EOF

#!/usr/bin/env bash
set -euo pipefail

FILE="${BACKUP_FILE:-$BACKUP_PATH}"
RAW_SIZE="$(du -s /data | awk '{print $1}')"
ZIP_SIZE="$(stat -c%s "$FILE")"
COMPR_PCT=$(awk -v r="$RAW_SIZE" -v z="$ZIP_SIZE" \
  'BEGIN {printf "%.1f", (1 - z/r) * 100}')
DURATION_SEC="${BACKUP_DURATION_SEC:-$SECONDS}"

# jogadores online
PLAYERS="$(mcrcon -H "$RCON_HOST" -P "$RCON_PORT" \
  -p "$RCON_PASSWORD" 'list' | sed -n 's/^There are \([0-9]*\) .*$/\1/p')"

# próximo agendamento simples (usa BACKUP_INTERVAL=2h, 30m, etc.)
NEXT_RUN="$(date -u -d "now + ${BACKUP_INTERVAL:-2h}" '+%Y-%m-%dT%H:%M:%SZ')"

json=$(jq -n --arg host "$RCON_HOST" \
             --arg file "$(basename "$FILE")" \
             --arg zipsize "$(numfmt --to=iec $ZIP_SIZE)" \
             --arg rawsize "$(numfmt --to=iec $RAW_SIZE)" \
             --arg pct "$COMPR_PCT" \
             --arg dur "$(printf "%02dm%02ds" $((DURATION_SEC/60)) $((DURATION_SEC%60)))" \
             --arg players "$PLAYERS" \
             --arg next "$NEXT_RUN" \
             '{
                username:"Minecraft‑Backup",
                embeds:[{
                  title:"Backup concluído",
                  description:( "Servidor **" + $host + "** salvo com êxito"),
                  fields:[
                    {name:"Arquivo",   value:$file, inline:true},
                    {name:"Compactado",value:$zipsize, inline:true},
                    {name:"Bruto",     value:$rawsize, inline:true},
                    {name:"Compressão",value:($pct + "%"), inline:true},
                    {name:"Duração",   value:$dur, inline:true},
                    {name:"Players Online", value:$players, inline:true},
                    {name:"Próximo",   value:$next, inline:false}
                  ],
                  timestamp: (now|todate)
                }]
              }')

curl -sS -H "Content-Type: application/json" -d "$json" "$DISCORD_WEBHOOK_URL"

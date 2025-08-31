# Docker Minecraft Server Setup

Este projeto configura e gerencia um servidor Minecraft "All the Mods 10" utilizando Docker

## Estrutura do Projeto

- **`docker-compose.yml`**: Define os serviços Docker para o servidor Minecraft, incluindo o servidor modded, proxy LazyMC, agente Playit e backups.
- **`scripts/post-backup-discord.sh`**: Script para enviar notificações ao Discord após a conclusão de um backup.
- **`.env`**: Arquivo de configuração para variáveis de ambiente sensíveis (adicionado ao `.gitignore`).
- **`/srv/docker/minecraft/allthemods`**: Diretório no host para armazenar os dados do servidor.

## Serviços Configurados

### 1. **Playit**
- Proxy para expor o servidor Minecraft na internet.
- Imagem: `ghcr.io/playit-cloud/playit-agent:0.15`.

### 2. **LazyMC**
- Proxy inteligente que coloca o servidor Minecraft em modo de descanso quando inativo e o desperta automaticamente quando jogadores tentam se conectar.
- Economiza recursos do sistema ao desligar servidores ociosos, especialmente útil para servidores modded que consomem muita memória/CPU.
- Imagem: `ghcr.io/joesturge/lazymc-docker-proxy:latest`.

### 3. **All The Mods 10**
- Servidor Minecraft com o modpack do CurseForge.
- Modpack: All the Mods 10 - ATM10.
- Versão: 1.21.1.
- Imagem: `itzg/minecraft-server:java21`.
  
## Pré-requisitos

- Docker e Docker Compose instalados.
- Variáveis de ambiente configuradas no arquivo `.env`:
  - `SECRET_KEY`: Chave secreta para o Playit.
  - `CF_API_KEY`: Chave de API do CurseForge.
  - `OPS`: Nome de usuário do(s) operador(es) do servidor.
  - `DISCORD_WEBHOOK_URL`: URL do webhook do Discord para notificações de backup.

## Configuração

1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/smart-minecraft.git
   cd smart-minecraft/server
   ```

2. Crie e configure o arquivo `.env` a partir do `example.env` com suas variáveis de ambiente.

3. Inicie os serviços:
   ```bash
   docker-compose up -d
   ```

4. Verifique os logs para garantir que tudo está funcionando:
   ```bash
   docker-compose logs -f
   ```

## Personalização

- **Modpack**: Configure o modpack no serviço `allthemods` no arquivo `docker-compose.yml`.
- **Intervalo de backups**: Altere a variável `BACKUP_INTERVAL` no serviço `backups`.
- **Notificações no Discord**: Personalize o script `scripts/post-backup-discord.sh`.

## Troubleshooting

- Certifique-se de que as variáveis de ambiente estão configuradas corretamente no `.env`.
- Verifique os logs dos serviços para identificar problemas:
  ```bash
  docker-compose logs <nome-do-serviço>
  ```

## Licença

Este projeto é de uso pessoal e não possui uma licença específica. Sinta-se à vontade para adaptá-lo às suas necessidades.
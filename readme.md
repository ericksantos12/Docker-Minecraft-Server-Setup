# Docker Minecraft Server Setup

Este projeto configura e gerencia servidores Minecraft utilizando Docker, com suporte para backups automáticos, notificações no Discord e integração com modpacks do CurseForge e Modrinth.

## Estrutura do Projeto

- **`docker-compose.yml`**: Define os serviços Docker para o servidor Minecraft, incluindo servidores modded, proxy LazyMC, agente Playit e backups automáticos.
- **`scripts/post-backup-discord.sh`**: Script para enviar notificações ao Discord após a conclusão de um backup.
- **`.env`**: Arquivo de configuração para variáveis de ambiente sensíveis (adicionado ao `.gitignore`).
- **`data-raspberry` e `data-vanilla`**: Volumes Docker para armazenar os dados dos servidores.

## Serviços Configurados

### 1. **Playit**
- Proxy para expor o servidor Minecraft na internet.
- Imagem: `ghcr.io/playit-cloud/playit-agent:0.15`.

### 2. **LazyMC**
- Proxy inteligente que coloca o servidor Minecraft em modo de descanso quando inativo e o desperta automaticamente quando jogadores tentam se conectar.
- Economiza recursos do sistema ao desligar servidores ociosos, especialmente útil para servidores com mods que consomem muita memória/CPU.
- Imagem: `ghcr.io/joesturge/lazymc-docker-proxy:latest`.

### 3. **Raspberry**
- Servidor Minecraft com modpack do CurseForge.
- Modpack: Raspberry Flavoured 3.0 Pre-Release 4.
- Versão: 1.19.2.
- Imagem: `itzg/minecraft-server:java21`.

### 4. **Vanilla**
- Servidor Minecraft com modpack do Modrinth.
- Modpack: Vanilla.
- Versão: 1.21.4.
- Imagem: `itzg/minecraft-server:java21`.

### 5. **Backups**
- Serviço para realizar backups automáticos dos servidores.
- Notifica o Discord após cada backup.
- Imagem: `itzg/mc-backup:latest`.
  
## Pré-requisitos

- Docker e Docker Compose instalados.
- Variáveis de ambiente configuradas no arquivo `.env`:
  - `SECRET_KEY`: Chave secreta para o Playit.
  - `CF_API_KEY`: Chave de API do CurseForge.
  - `DISCORD_WEBHOOK_URL`: URL do webhook do Discord para notificações.
  - Outras variáveis como `MEMORY`, `USE_AIKAR_FLAGS`, `PVP`, etc.

## Configuração

1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/smart-minecraft.git
   cd smart-minecraft/server
   ```

2. Configure o arquivo `.env` com suas variáveis de ambiente.

3. Inicie os serviços:
   ```bash
   docker-compose up -d
   ```

4. Verifique os logs para garantir que tudo está funcionando:
   ```bash
   docker-compose logs -f
   ```

## Backups e Notificações

- Os backups são realizados automaticamente a cada 2 horas (configurável via `BACKUP_INTERVAL`).
- Após cada backup, uma notificação é enviada ao Discord com informações como:
  - Nome do arquivo de backup.
  - Tamanho compactado e bruto.
  - Porcentagem de compressão.
  - Duração do backup.
  - Jogadores online no momento do backup.
  - Próximo agendamento.

## Personalização

- **Modpacks**: Configure os modpacks no serviço `raspberry` ou `vanilla` no arquivo `docker-compose.yml`.
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
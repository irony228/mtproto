#!/bin/bash

# Домен-маскировка (update.microsoft.com отлично подходит, его не блочат)
FAKE_DOMAIN="update.microsoft.com"
PORT="443"
IP=$(curl -s ifconfig.me)

log() {
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}$1${NC}"
}

log "1. Скачиваем движок mtg v2 и генерируем настоящий FakeTLS секрет..."
# mtg сам генерирует идеальный HEX-секрет с префиксом ee и зашитым доменом
SECRET=$(docker run --rm nineseconds/mtg:2 generate-secret --hex $FAKE_DOMAIN)

log "2. Создаем файл настроек config.toml..."
cat > config.toml << EOF
secret = "${SECRET}"
bind-to = "0.0.0.0:${PORT}"
EOF

log "3. Запускаем прокси..."
docker compose up -d

log "================================================="
log "🚀 УСПЕХ! ПРОКСИ РАБОТАЕТ НА ДВИЖКЕ MTG V2"
log "================================================="
log "IP: $IP"
log "PORT: $PORT"
log "DOMAIN: $FAKE_DOMAIN"
log ""
log "🔗 ССЫЛКА ДЛЯ ПОДКЛЮЧЕНИЯ:"
echo -e "\033[0;33mtg://proxy?server=${IP}&port=${PORT}&secret=${SECRET}\033[0m"
log "================================================="
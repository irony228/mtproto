#!/bin/bash

FAKE_DOMAIN="update.microsoft.com"
PORT="444"
IP=$(curl -s ifconfig.me)

log() {
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}$1${NC}"
}

# Проверяем, существует ли уже файл config.toml
if [ -f "config.toml" ]; then
    log "1. Нашел существующий config.toml! Использую старый ключ..."
    # Вытаскиваем старый секрет из файла, чтобы корректно собрать ссылку в конце
    SECRET=$(grep 'secret =' config.toml | cut -d '"' -f 2)
else
    log "1. Файл настроек не найден. Скачиваем движок mtg v2 и генерируем секрет..."
    SECRET=$(docker run --rm nineseconds/mtg:2 generate-secret --hex $FAKE_DOMAIN)
    
    log "2. Создаем файл настроек config.toml..."
    cat > config.toml << EOF
secret = "${SECRET}"
bind-to = "0.0.0.0:${PORT}"
EOF
fi

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
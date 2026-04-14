#!/bin/bash

log() {
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}$1${NC}"
}

error() {
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}$1${NC}" >&2
}

log "Останавливаю прокси-сервер mtg..."

docker compose down

if [[ $? -eq 0 ]]; then
    log "✅ Сервис успешно остановлен и удален из памяти!"
else
    error "❌ Что-то пошло не так при остановке..."
fi
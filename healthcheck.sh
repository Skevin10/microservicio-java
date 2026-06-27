#!/bin/bash

# Variables configurables
HOST="${HC_HOST:-localhost}"
PORT="${HC_PORT:-8081}"
LOG_FILE="${HC_LOG:-healthcheck.log}"

# URL del health endpoint
HEALTH_URL="http://${HOST}:${PORT}/health"

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Función para loguear
log_message() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

# Verificar si el servicio responde
HTTP_CODE=$(curl -s -o /tmp/health_response.txt -w "%{http_code}" "$HEALTH_URL" 2>&1)
BODY=$(cat /tmp/health_response.txt)

# Registrar resultado
if [ "$HTTP_CODE" = "200" ]; then
    log_message "✓ Health check OK - HTTP 200 - Body: $BODY"
    exit 0
else
    log_message "✗ Health check FAILED - HTTP $HTTP_CODE"
    exit 1
fi

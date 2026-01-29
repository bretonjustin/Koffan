#!/usr/bin/with-contenv bashio

# Read configuration from Home Assistant
export APP_PASSWORD=$(bashio::config 'password')
export DEFAULT_LANG=$(bashio::config 'language')

# Optional API token
API_TOKEN_CONFIG=$(bashio::config 'api_token')
if [ -n "$API_TOKEN_CONFIG" ]; then
    export API_TOKEN="$API_TOKEN_CONFIG"
fi

# Database path - use HA addon config directory for persistence
export DB_PATH=/config/shopping.db
export PORT=3000
export APP_ENV=production

bashio::log.info "Starting Koffan..."
bashio::log.info "Database: ${DB_PATH}"
bashio::log.info "Language: ${DEFAULT_LANG}"

exec /app/shopping-list

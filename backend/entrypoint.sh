#!/bin/bash
set -e

# Passo 1: Remove lixo de execuções anteriores
rm -f /app/tmp/pids/server.pid

# Passo 2: Garante que o banco está pronto (Cria/Migra/Seeds)
echo "Preparando banco de dados..."
bundle exec rails db:prepare

# Passo 3: Sobe o servidor de fato
exec "$@"
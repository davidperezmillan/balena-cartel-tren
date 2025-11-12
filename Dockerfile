FROM ollama/ollama:latest

# Instalar curl para health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Modelo a descargar (configurable via variable de entorno)
ENV MODEL=${MODEL}

# Copiar script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Usar el script como entrypoint
ENTRYPOINT ["/entrypoint.sh"]

#!/bin/bash
set -e

# Función para esperar a que Ollama esté listo
wait_for_ollama() {
    echo "Esperando a que Ollama esté listo..."
    for i in {1..30}; do
        echo "Intento $i..."
        if curl -s http://127.0.0.1:11434/api/version > /dev/null 2>&1; then
            echo "Ollama está listo"
            return 0
        fi
        sleep 2
    done
    echo "Ollama no respondió después de 60 segundos"
    return 1
}

# Iniciar servidor de Ollama en background
echo "Iniciando servidor de Ollama..."
ollama serve &
server_pid=$!

# Esperar a que esté listo
wait_for_ollama

# Descargar modelo si no existe
if ! ollama list | grep -q "$MODEL"; then
    echo "Descargando modelo $MODEL..."
    ollama pull "$MODEL"
else
    echo "Modelo $MODEL ya está instalado"
fi

# Mantener el contenedor corriendo esperando al servidor
wait $server_pid
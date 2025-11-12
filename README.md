# AI Custom Project - Ollama & Open-WebUI

[![Deploy with Balena](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/davidperezmillan/balena-cartel-tren&defaultDeviceType=raspberrypi4-64&defaultFleet=g_david_perez_millan/balena-secondary-server)

Un proyecto completo de inteligencia artificial que combina **Ollama** (servidor de modelos de IA local) con **Open-WebUI** (interfaz web moderna) para crear tu propia plataforma de IA autoalojada.

## 🚀 Características

- **Ollama Server**: Ejecuta modelos de IA localmente sin necesidad de internet
- **Open-WebUI**: Interfaz web intuitiva similar a ChatGPT
- **Docker Compose**: Configuración containerizada para fácil despliegue
- **Balena Cloud**: Despliegue automático en dispositivos IoT
- **Modelo preconfigurado**: JOSIEFIED-Qwen3:0.6b (optimizado para dispositivos con recursos limitados)

## 📋 Requisitos

### Para Balena Cloud
- Cuenta en [Balena Cloud](https://balena.io/)
- Dispositivo compatible (Raspberry Pi 4 recomendado)
- Conexión a internet para la descarga inicial

### Para despliegue local
- Docker y Docker Compose instalados
- Al menos 4GB de RAM disponible
- 10GB de espacio en disco libre

## 🔧 Configuración

### Variables de Entorno

| Variable | Valor por defecto | Descripción |
|----------|-------------------|-------------|
| `MODEL` | `goekdenizguelmez/JOSIEFIED-Qwen3:0.6b` | Modelo de IA a descargar |
| `OLLAMA_BASE_URL` | `http://ollama:11434` | URL del servidor Ollama |

### Puertos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Ollama | 11434 | API del servidor de modelos |
| Open-WebUI | 3000 | Interfaz web (solo en modo local) |

## 🚀 Despliegue

### Opción 1: Balena Cloud (Recomendado)

1. **Haz clic en el botón Deploy with Balena** ⬆️
2. **Configura tu aplicación**:
   - Fleet: `g_david_perez_millan/balena-secondary-server`
   - Dispositivo: Raspberry Pi 4 (recomendado)
3. **Flashea tu dispositivo** con BalenaOS
4. **Conecta tu dispositivo** a internet
5. **Accede a tu aplicación** a través del dashboard de Balena

### Opción 2: Docker Compose Local

```bash
# Clonar el repositorio
git clone https://github.com/davidperezmillan/balena-cartel-tren.git
cd balena-cartel-tren

# Ejecutar con interfaz web (recomendado para desarrollo)
docker-compose -f docker-compose-local.yaml up -d

# O solo Ollama (para producción)
docker-compose up -d
```

### Opción 3: Docker manual

```bash
# Construir la imagen
docker build -t ai-custom .

# Ejecutar solo Ollama
docker run -d \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  --name ollama-service \
  ai-custom

# Ejecutar Open-WebUI (opcional)
docker run -d \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL=http://ollama-service:11434 \
  -v webui_data:/app/backend/data \
  --link ollama-service \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

## 💻 Uso

### Acceso a la Interfaz Web
- **Desarrollo local**: http://localhost:3000
- **Balena Cloud**: Usar la URL pública proporcionada en el dashboard

### API de Ollama
- **Endpoint**: http://localhost:11434 (o la IP de tu dispositivo Balena)
- **Documentación**: [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md)

### Comandos básicos

```bash
# Listar modelos disponibles
curl http://localhost:11434/api/tags

# Generar respuesta
curl http://localhost:11434/api/generate -d '{
  "model": "goekdenizguelmez/JOSIEFIED-Qwen3:0.6b",
  "prompt": "¿Qué es la inteligencia artificial?",
  "stream": false
}'

# Health check
curl http://localhost:11434/api/version
```

## 🔧 Personalización

### Cambiar el modelo de IA

1. **Editar el Dockerfile**:
```dockerfile
ENV MODEL=tu-modelo-preferido
```

2. **O usar variable de entorno**:
```bash
docker run -e MODEL=llama2:7b ai-custom
```

### Modelos recomendados por tamaño

| Modelo | Tamaño | RAM necesaria | Casos de uso |
|--------|---------|---------------|--------------|
| `qwen2.5:0.5b` | ~0.5GB | 2GB | Dispositivos muy limitados |
| `qwen2.5:1.5b` | ~1.5GB | 4GB | Raspberry Pi 4 |
| `llama3.2:3b` | ~3GB | 6GB | Servidores pequeños |
| `qwen2.5:7b` | ~7GB | 12GB | Workstations |

### Personalizar Open-WebUI

Montar configuraciones personalizadas:
```yaml
volumes:
  - ./config:/app/backend/data
```

## 📂 Estructura del Proyecto

```
.
├── Dockerfile                 # Imagen personalizada de Ollama
├── docker-compose.yaml        # Solo Ollama (producción)
├── docker-compose-local.yaml  # Ollama + WebUI (desarrollo)
├── entrypoint.sh             # Script de inicialización
├── .gitignore                # Archivos excluidos del control de versiones
└── README.md                 # Esta documentación
```

## 🛠 Desarrollo

### Logs y debugging

```bash
# Ver logs de Ollama
docker logs ollama-service -f

# Ver logs de WebUI
docker logs open-webui -f

# Acceder al contenedor
docker exec -it ollama-service bash
```

### Actualizar modelos

```bash
# Entrar al contenedor
docker exec -it ollama-service bash

# Actualizar modelo
ollama pull goekdenizguelmez/JOSIEFIED-Qwen3:0.6b

# Listar modelos
ollama list
```

## 🚨 Solución de Problemas

### El modelo no se descarga
- Verificar conexión a internet
- Comprobar espacio en disco disponible
- Revisar logs: `docker logs ollama-service`

### WebUI no conecta con Ollama
- Verificar que `OLLAMA_BASE_URL` apunte correctamente
- Comprobar que Ollama esté ejecutándose
- Verificar conectividad de red entre contenedores

### Rendimiento lento
- Considerar un modelo más pequeño
- Aumentar RAM disponible
- Usar SSD en lugar de microSD (Raspberry Pi)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

## 🙏 Reconocimientos

- [Ollama](https://ollama.ai/) - Servidor de modelos de IA local
- [Open-WebUI](https://github.com/open-webui/open-webui) - Interfaz web moderna
- [Balena](https://balena.io/) - Plataforma IoT para despliegue
- [JOSIEFIED-Qwen3](https://huggingface.co/goekdenizguelmez/JOSIEFIED-Qwen3) - Modelo de IA optimizado

## 📧 Contacto

David Pérez Millán - [@davidperezmillan](https://github.com/davidperezmillan)

Enlace del proyecto: [https://github.com/davidperezmillan/balena-cartel-tren](https://github.com/davidperezmillan/balena-cartel-tren)
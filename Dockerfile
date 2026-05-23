# Жестко фиксируем архитектуру сборщика под сервера Render
FROM --platform=linux/amd64 ubuntu:22.04

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем папки
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скрипт сам определит архитектуру сервера (Render использует amd64) и скачает правильный файл
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then TS_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then TS_ARCH="arm64"; \
    else TS_ARCH="amd64"; fi && \
    curl -L -o /torrserver/TorrServer "https://github.com{TS_ARCH}"

# Даем права
RUN chmod +x /torrserver/TorrServer

EXPOSE 8090

CMD ["/torrserver/TorrServer", "-p", "8090", "-d", "/torrserver/db"]

FROM ubuntu:22.04

# Используем встроенную переменную Docker для определения архитектуры сборки
ARG TARGETARCH

# Устанавливаем curl и сертификаты
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скрипт автоматически скачает нужный файл: amd64 для Intel или arm64 для ARM процессоров
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        TS_ARCH="arm64"; \
    else \
        TS_ARCH="amd64"; \
    fi && \
    curl -L -o /torrserver/TorrServer "https://github.com{TS_ARCH}"

# Выдаем права на запуск
RUN chmod +x /torrserver/TorrServer

EXPOSE 8090

CMD ["/torrserver/TorrServer", "-p", "8090", "-d", "/torrserver/db"]

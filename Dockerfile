FROM ubuntu:22.04

# Устанавливаем curl и сертификаты
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скачиваем актуальную версию MatriX.137 по проверенным прямым ссылкам
RUN curl -L -o /torrserver/TorrServer-amd64 https://github.com
RUN curl -L -o /torrserver/TorrServer-arm64 https://github.com

# Создаем универсальный скрипт запуска
RUN echo '#!/bin/sh' > /torrserver/start.sh && \
    echo 'if [ "$(uname -m)" = "aarch64" ]; then' >> /torrserver/start.sh && \
    echo '  chmod +x /torrserver/TorrServer-arm64 && exec /torrserver/TorrServer-arm64 "$@"' >> /torrserver/start.sh && \
    echo 'else' >> /torrserver/start.sh && \
    echo '  chmod +x /torrserver/TorrServer-amd64 && exec /torrserver/TorrServer-amd64 "$@"' >> /torrserver/start.sh && \
    echo 'fi' >> /torrserver/start.sh

# Даем права на запуск скрипта
RUN chmod +x /torrserver/start.sh

EXPOSE 8090

# Запуск
CMD ["/torrserver/start.sh", "-p", "8090", "-d", "/torrserver/db"]

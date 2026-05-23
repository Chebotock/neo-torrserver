FROM ubuntu:22.04

# Устанавливаем curl и сертификаты
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скачиваем сразу ОБА файла (для обычных процессоров и для ARM). Весят они мало.
RUN curl -L -o /torrserver/TorrServer-amd64 https://github.com
RUN curl -L -o /torrserver/TorrServer-arm64 https://github.com

# Создаем хитрый универсальный скрипт запуска, который сам выберет нужный файл на ходу
RUN echo '#!/bin/sh' > /torrserver/start.sh && \
    echo 'if [ "$(uname -m)" = "aarch64" ]; then' >> /torrserver/start.sh && \
    echo '  chmod +x /torrserver/TorrServer-arm64 && exec /torrserver/TorrServer-arm64 "$@"' >> /torrserver/start.sh && \
    echo 'else' >> /torrserver/start.sh && \
    echo '  chmod +x /torrserver/TorrServer-amd64 && exec /torrserver/TorrServer-amd64 "$@"' >> /torrserver/start.sh && \
    echo 'fi' >> /torrserver/start.sh

# Даем права на запуск скрипта-переключателя
RUN chmod +x /torrserver/start.sh

EXPOSE 8090

# Запускаем наш универсальный скрипт, который сам выберет файл без ошибок формата exec
CMD ["/torrserver/start.sh", "-p", "8090", "-d", "/torrserver/db"]

FROM ubuntu:22.04

# Устанавливаем curl и сертификаты
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем папку для хранения базы данных TorrServer и даем ей права
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скачиваем официальный TorrServer
RUN curl -L -o /torrserver/TorrServer https://github.com
RUN chmod +x /torrserver/TorrServer

# Открываем порт
EXPOSE 8090

# Запускаем сервер, жестко указав путь к его рабочей папке базы данных (-d)
CMD ["/torrserver/TorrServer", "-p", "8090", "-d", "/torrserver/db"]

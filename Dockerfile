FROM ubuntu:22.04

# Устанавливаем curl и сертификаты безопасности
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Создаем рабочую папку сервера
RUN mkdir -p /torrserver/db && chmod -R 777 /torrserver

# Скачиваем файл по прямой, фиксированной ссылке для серверов Render (amd64)
RUN curl -L -o /torrserver/TorrServer https://github.com

# Выдаем права на запуск программы
RUN chmod +x /torrserver/TorrServer

# Открываем порт
EXPOSE 8090

# Запускаем TorrServer
CMD ["/torrserver/TorrServer", "-p", "8090", "-d", "/torrserver/db"]

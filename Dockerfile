FROM ubuntu:22.04

# Устанавливаем необходимые утилиты (curl и сертификаты)
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Скачиваем официальный исполняемый файл TorrServer (версия Matrix)
RUN curl -L -o /TorrServer https://github.com

# Даем права на запуск
RUN chmod +x /TorrServer

# Открываем порт для Lampa
EXPOSE 8090

# Запуск сервера
CMD ["/TorrServer", "-p", "8090"]

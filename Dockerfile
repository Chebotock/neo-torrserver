#Указывает базовый образ для создания нового образа
FROM ubuntu:18.04 

#Необязательная команда, указывает имя владельца образа.
MAINTAINER Denis Fofanov <fofanovdenis43@gmail.com> 

#Обновляем все пакеты и создаём нужные директории для скачивания и установки torrserver
#Не забывайте брать свежую ссылку на TorrServer иначе поставит 1.1.77
RUN  apt-get update && apt-get install -y wget &&  \ 
   mkdir /torrserver/ && cd /torrserver/ && mkdir /db &&  \
   wget -O TorrServer -P /torrserver/ "https://github.com/YouROK/TorrServer/releases/download/1.1.77/TorrServer-linux-amd64" &&  \
   chmod +x /torrserver/TorrServer

# Указывает какие порты будут слушаться в контейнере.
EXPOSE 8090:8090

ENTRYPOINT ["/torrserver/TorrServer"]

#Монтирует директорию хоста в контейнер.
#Это папка с настройками TorrServer на вашем сервере. Иначе настройки не будут сохранятся после перезапуска.
VOLUME ["--path" "/torrserver/db"]

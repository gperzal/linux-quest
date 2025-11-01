# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar utilidades básicas y conversor de formato
RUN apt-get update && apt-get install -y \
    bash coreutils findutils procps nano vim tree less grep dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root
RUN useradd -ms /bin/bash programmer

# Copiar archivos del juego
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY assets/STORY.txt /opt/quest/STORY.txt

# 🔧 Conversión y permisos correctos dentro del contenedor
RUN dos2unix /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

# Asignar permisos y dueño
RUN chown -R programmer:programmer /opt/quest

USER programmer
WORKDIR /home/programmer

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

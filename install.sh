#!/bin/bash
# Установка зависимостей для сборки SS13 (TG-билд)

# Обновление системы
sudo apt update && sudo apt install -y \
    wget unzip curl libglu1-mesa libx11-6 make

# Скачивание и установка BYOND
cd /tmp
wget https://www.byond.com/download/build/514/516.1664_byond_linux.zip
unzip 516.1664_byond_linux.zip
cd byond
make here

# Добавление BYOND в PATH
export PATH="$PATH:/tmp/byond"
echo 'export PATH="$PATH:/tmp/byond"' >> ~/.bashrc

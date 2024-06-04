#!/bin/bash

# Встановити необхідні пакети
sudo yum update -y
sudo yum install -y git python3-pip docker

# Встановити Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Запустити Docker
sudo service docker start
sudo usermod -aG docker ec2-user

# Клонувати репозиторій
git clone https://github.com/mavi-fiot/IITLR45v3ins.git

# Перейти до папки з файлами Git репозиторію
cd IITLR45v3ins

# Створити імейдж та запушити його у Docker репозиторій
docker build -t mavidoc/iitlr45v3ins:latest .
docker push mavidoc/iitlr45v3ins:latest

# Виконати Docker Compose build
docker-compose build

# Запустити у фоновому режимі Docker Compose up
docker-compose up -d

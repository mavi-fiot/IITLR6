#!/bin/bash

# 1. Підключитись до інстансу
ssh -i "C:\Users\MAVi\OneDrive\ФІОТ-матеріали\6_СЕМЕСТР\ІІТ\ЛР\ЛР45\lr45v4.pem" ec2-user@ec2-18-191-68-86.us-east-2.compute.amazonaws.com

# 2. Отримати файли з Git репозиторію
https://github.com/mavi-fiot/IITLR45v3ins

# 3. Перейти до папки з файлами Git репозиторію
cd IITLR45v3ins
sudo yum install python3-pip -y
sudo yum install docker -y
sudo sudo durl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo pip install docker-compose
# 4. Створити імейдж та запушити його у Docker репозиторій
docker build -t mavidoc/iitlr45v3ins:latest .
docker push mavidoc/iitlr45v3ins:latest

# 5. Виконати Docker Compose build
docker-compose build

# 6. Запустити у фоновому режимі Docker Compose up
docker-compose up -d

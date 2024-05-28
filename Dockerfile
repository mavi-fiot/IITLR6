# Використовуємо офіційний образ Nginx в якості бази
FROM nginx:latest

# Копіюємо файли застосунку в контейнер
COPY . /usr/share/nginx/html/

# Налаштування Nginx
COPY nginx.conf /etc/nginx/nginx.conf
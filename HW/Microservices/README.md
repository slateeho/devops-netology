# Микросервисы

<details>
<summary> Микросервисы: принципы</summary>

## Задача 1 – API Gateway

### Сравнительная таблица

| Решение        | Маршрутизация | Проверка аутентификации                 | Терминация HTTPS | Расширяемость                | Простота эксплуатации | Примечание |
|----------------|---------------|------------------------------------------|------------------|------------------------------|------------------------|------------|
| **NGINX**      | Да            | Да (auth_request, Lua)                   | Да               | Модули, Lua                  | Просто                | Лёгкий, стабильный, идеален для Docker/VM, подходит для кастомных схем аутентификации. |
| **Kong**       | Да            | Да (JWT, OAuth2, ACL, внешние авторизаторы) | Да           | Очень высокая (Lua плагины) | Средняя               | Зрелый OSS‑гейт, богатая экосистема, поддержка service discovery. |
| **KrakenD**    | Да            | Да (JWT, внешние валидаторы)            | Да               | Очень высокая (Go плагины)  | Средняя               | High‑performance gateway: stateless‑кластер, агрегация/трансформации, DNS SRV, etcd. |
| **Traefik**    | Да            | Да (middleware)                          | Да               | Плагины, динамическая конфигурация | Просто         | Отлично подходит для Docker/K8s, auto‑discovery сервисов. |
| **AWS API GW** | Да            | Да                                       | Да               | AWS экосистема               | Просто (облако)       | Управляемый сервис, идеален для serverless. |

**Выбор:** NGINX

**Обоснование:**
- Полностью удовлетворяет требованиям: маршрутизация, проверка аутентификации, терминация HTTPS
- Легковесный и стабильный
- Просто развернуть в Docker
- Поддерживает внешнюю аутентификацию через auth_request

---

## Задача 2 – Брокер сообщений

### Сравнительная таблица

| Брокер   | Кластеризация | Сохранение на диск | Скорость | Форматы | ACL | Простота |
|----------|---------------|--------------------|----------|---------|-----|----------|
| RabbitMQ | Да            | Да                 | Высокая  | Любые   | Да  | Просто   |
| Kafka    | Да            | Да                 | Очень высокая | Любые | Да  | Сложно   |
| NATS     | Да (JetStream)| Да                 | Очень высокая | Любые | Да  | Средне   |
| ActiveMQ | Да            | Да                 | Средняя  | Любые   | Да  | Средне   |

**Выбор:** RabbitMQ

**Обоснование:**
- Удовлетворяет всем требованиям
- Проще в эксплуатации чем Kafka
- Надёжная доставка сообщений
- Хорошая система ACL

---

## Задача 3 – API Gateway (NGINX + Docker Compose)

### docker-compose.yml

```yaml
version: "3.9"

services:
  gateway:
    image: nginx:alpine
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:80"
    depends_on:
      - security
      - uploader
      - minio

  security:
    image: security-service:latest
    expose:
      - "8080"

  uploader:
    image: uploader-service:latest
    expose:
      - "8080"

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    expose:
      - "9000"
      - "9001"
```

### nginx.conf

```nginx
worker_processes 1;

events {
  worker_connections 1024;
}

http {
  upstream security_service {
    server security:8080;
  }

  upstream uploader_service {
    server uploader:8080;
  }

  upstream minio_service {
    server minio:9000;
  }

  server {
    listen 80;

    # Аутентификация через subrequest
    location = /v1/auth {
      internal;
      proxy_pass http://security_service/v1/token/validation;
      proxy_pass_request_body off;
      proxy_set_header Content-Length "";
      proxy_set_header Authorization $http_authorization;
    }

    # Публичные эндпоинты
    location = /v1/register {
      proxy_pass http://security_service/v1/user;
    }

    location = /v1/token {
      proxy_pass http://security_service/v1/token;
    }

    # Защищённые эндпоинты
    location = /v1/user {
      auth_request /v1/auth;
      proxy_pass http://security_service/v1/user;
    }

    location = /v1/upload {
      auth_request /v1/auth;
      proxy_pass http://uploader_service/v1/upload;
    }

    location /v1/images/ {
      auth_request /v1/auth;
      proxy_pass http://minio_service;
    }
  }
}
```
</details>

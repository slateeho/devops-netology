from datetime import datetime
import os
import time
from contextlib import contextmanager, asynccontextmanager

import mysql.connector
from fastapi import FastAPI, Request, Depends, Header
from typing import Optional


# --- 1. Конфигурация ---
# Считываем конфигурацию БД из переменных окружения
db_host = os.environ.get('DB_HOST')
db_user = os.environ.get('MYSQL_USER')
db_password = os.environ.get('MYSQL_PASSWORD')
db_name = os.environ.get('MYSQL_DATABASE')
db_table = os.environ.get('MYSQL_TABLE')
db_auth_plugin = 'caching_sha2_password'

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Код, который выполнится перед запуском приложения
    print("Приложение запускается...")
    try:
        # Retry loop to wait for MySQL
        db = None
        for attempt in range(10):
            try:
                db = mysql.connector.connect(
                    host=db_host,
                    user='root',
                    password=os.environ.get('MYSQL_ROOT_PASSWORD')
                )
                break
            except mysql.connector.Error as err:
                print(f"MySQL not ready yet (attempt {attempt + 1}/10): {err}")
                time.sleep(3)
        else:
            print("MySQL did not become ready in time.")
            yield
            return
        
        cursor = db.cursor()
        # Create database if not exists
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS `{db_name}`")
        db.commit()
        cursor.close()
        db.close()
        
        # Connect to database
        db = mysql.connector.connect(
            host=db_host,
            user='root',
            password=os.environ.get('MYSQL_ROOT_PASSWORD'),
            database=db_name
        )
        cursor = db.cursor()
        create_user_query = f"""
        CREATE USER IF NOT EXISTS '{db_user}'@'%' IDENTIFIED WITH {db_auth_plugin} BY '{db_password}';
        GRANT ALL PRIVILEGES ON `{db_name}`.* TO '{db_user}'@'%';
        FLUSH PRIVILEGES;
        """
        cursor.execute(create_user_query)
        db.commit()
        # Create table
        create_table_query = f"""
        CREATE TABLE IF NOT EXISTS `{db_table}` (
            id INT AUTO_INCREMENT PRIMARY KEY,
            request_date DATETIME,
            request_ip VARCHAR(255)
        )
        """
        cursor.execute(create_table_query)
        db.commit()
        print(f"Соединение с БД установлено и таблица \'{db_table}\' готова к работе.")
        cursor.close()
        db.close()
    except mysql.connector.Error as err:
        print(f"Ошибка при подключении к БД или создании таблицы: {err}")

    yield

    # Код, который выполнится при остановке приложения
    print("Приложение останавливается.")


# Создаем экземпляр FastAPI с использованием lifespan
app = FastAPI(
    title="Shvirtd Example FastAPI",
    description="Учебный проект, FastAPI+Docker.",
    version="1.0.0",
    lifespan=lifespan
)


# --- 2. Управление соединением с БД ---
@contextmanager
def get_db_connection():
    db = None
    try:
        db = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        yield db
    finally:
        if db is not None and db.is_connected():
            db.close()


# --- 3. Зависимость для получения IP ---
def get_client_ip(x_real_ip: Optional[str] = Header(None)):
    return x_real_ip


# --- 5. Основной эндпоинт ---
@app.get("/")
def index(request: Request, ip_address: Optional[str] = Depends(get_client_ip)):
    final_ip = ip_address  # Только из X-Forwarded-For, без fallback

    now = datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")

    try:
        with get_db_connection() as db:
            cursor = db.cursor()
            query = f"INSERT INTO `{db_table}` (request_date, request_ip) VALUES (%s, %s)"
            values = (current_time, final_ip)
            cursor.execute(query, values)
            db.commit()
            cursor.close()
    except mysql.connector.Error as err:
        return {"error": f"Ошибка при работе с базой данных: {err}"}

    # Подсказка для студентов при неправильном обращении
    if final_ip is None:
        ip_display = "похоже, что вы направляете запрос в неверный порт(например curl http://127.0.0.1:5001). Правильное выполнение задания - отправить запрос в порт 8090."
    else:
        ip_display = final_ip

    return f'TIME: {current_time}, IP: {ip_display}'


# --- 5. Отладочный эндпоинт ---
@app.get("/debug")
def debug_headers(request: Request):
    """Показывает все заголовки для отладки откуда берется IP"""
    return {
        "headers": dict(request.headers),
        "client_host": request.client.host if request.client else None,
        "x_forwarded_for": request.headers.get('x-forwarded-for'),
        "real_ip": request.headers.get('x-real-ip'),
        "forwarded": request.headers.get('forwarded')
    }


# --- 6. Эндпоинт для просмотра записей в БД ---
@app.get("/requests")
def get_requests():
    """Возвращает все записи из таблицы для проверки"""
    try:
        with get_db_connection() as db:
            cursor = db.cursor()
            query = f"SELECT id, request_date, request_ip FROM `{db_table}` ORDER BY id DESC LIMIT 50"
            cursor.execute(query)
            records = cursor.fetchall()
            cursor.close()

            # Преобразуем записи в читабельный формат
            result = []
            for record in records:
                result.append({
                    "id": record[0],
                    "request_date": record[1].strftime("%Y-%m-%d %H:%M:%S") if record[1] else None,
                    "request_ip": record[2]
                })

            return {
                "total_records": len(result),
                "records": result
            }
    except mysql.connector.Error as err:
        return {"error": f"Ошибка при чтении из базы данных: {err}"}


# --- 7. Запуск приложения ---
# Для запуска этого файла используется ASGI-сервер, например, uvicorn.
# Команда: uvicorn main:app --reload
if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=5000)

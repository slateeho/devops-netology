FROM python:3.12-slim

RUN pip install fastapi uvicorn mysql-connector-python

COPY . /app
WORKDIR /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"] 
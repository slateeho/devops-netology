# Мониторинг и логи

<details>
<summary>1. Средство визуализации Grafana</summary>

## Задание 1

утилизация CPU для nodeexporter (в процентах, 100-idle):

 `100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`

CPULA 1/5/15: `node_load1` `node_load5` `node_load15`

Количество свободной оперативной памяти; `{"node_memory_MemAvailable_bytes / 1024 / 1024 / 1024"}`

Количество места на файловой системе: `node_filesystem_avail_bytes{fstype!="tmpfs|devtmpfs|sshfs|squashfs|overlay"} / 1024 / 1024 / 1024` 

![Dashboard 1](./Grafana/pngs/1.png)

## Задание 2

![Dashboard 2](./Grafana/pngs/2.png)

## Задание 3

![Dashboard 3](./Grafana/pngs/3.png)

## Задание 4

[Dashboard JSON](./Grafana/netol2-dashboard.json)

</details>

<details>
<summary>2. Системы мониторинга</summary>

## Задание 1: Минимальный набор метрик для HTTP-сервиса с вычислениями

1. `http_request_duration_seconds{quantile="0.99"}` (alert > 2s)
2. `http_requests_total{status=~"5.."}` (rate > 1%)
3. `node_load1 / node_cpu_count` (alert > 1.5)
4. `node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes` (alert < 10%)
5. `computation_duration_seconds{quantile="0.99"}` (alert > SLA)

## Задание 2: Что означают технические метрики для продакт-менеджера

**RAM (Оперативная память)**
- Как размер рабочего стола: если мало места → вы спотыкаетесь и роняете вещи
- Когда RAM заканчивается → сервис начинает жутко тормозить и падает (нехватка памяти = нарушение SLA = клиенты жалуются)

**Inodes (Индексные узлы)**
- Как количество пустых ячеек в шкафу для новых папок
- Когда inodes кончаются → нельзя создать новые файлы, даже если место на диске есть (логи/отчеты не сохраняются, а потеря данных ведет к потере клиентов)

**Load Average (Средняя нагрузка)**
Высокий CPU Load Average — это ситуация, когда комманда получает больше задач, чем может обработать (например, `при деплое pipeline в пятницу`), и в результате начинает срывать свои “дедлайны”

## Задание 3: Решение для разработчиков без системы логов

### Dozzle

Один контейнер, показывает логи всех контейнеров в браузере. Использует 128MB RAM. Показывает real-time логи всех контейнеров с поиском и фильтрацией, нет проблем с конфигурацией

### Portainer

Полноценный UI для Docker с логами, статистикой ресурсов и управлением контейнерами. Использует 256MB RAM. Показывает логи контейнеров, статистику CPU/RAM, управление образами, сетями и volumes и имеет веб-терминал для доступа в контейнер

## Задание 4: Ошибка в расчете SLA

Не включены коды 3xx (редиректы):

```
SLA = (2xx + 3xx) / all_requests
```

## Задание 5: Pull vs Push модели мониторинга

### Push-модель

**Плюсы:**
- Агент отправляет данные сразу после сбора
- Не требует открытых портов на агентах
- Работает в NAT без дополнительной настройки
- Легче контролировать нагрузку на сеть

**Минусы:**

- Сложнее отладка
- Требует аутентификации на сервере
- Сложнее фильтровать метрики на сервере
- Требует балансировки нагрузки на сервере

### Pull-модель

**Плюсы:**
- Информация о доступности агентов
- Проще настройка (один сервер опрашивает многих)
- Более простой дебаг
- Легче фильтровать метрики
- Исключена потеря метрик

**Минусы:**
- Требует открытых портов на агентах
- Высокая нагрузка на сервер при большом количестве агентов

### Рекомендация

## Задание 6: Классификация систем мониторинга

| Система | Модель | Лицензия | Описание |
|---------|--------|----------|----------|
| Prometheus | Pull | open-source | стандарт для Kubernetes |
| TICK | Push | open-source | хороша для IoT |
| Zabbix | Hybrid | open-source | мощная с встроенным alerting |
| VictoriaMetrics | Hybrid | open-source | лучше Prometheus по производительности |
| Nagios | Pull | open-source | долговечна, незаменима в изолированных сетях,  госструктурах по всему миру |

## Задание 7: Запуск TICK стека:

[docker-compose.yml](./Monitoring_systems/docker-compose.yml) | [telegraf.conf](./Monitoring_systems/etc/telegraf.conf)

![1](./Monitoring_systems/pngs/1.png)

## Задание 8: Отображение метрик утилизации cpu из веб-интерфейса `telegraf`:

![2](./Monitoring_systems/pngs/2.png)

## Задание 8: Отображение метрик из веб-интерфейса `telegraf`, связанных с docker:

![3](./Monitoring_systems/pngs/3.png)


## Дополнительное задание

`а)` [monitoring_final.py](./Monitoring_systems/awesome_monitoring/monitoring_final.py)

`б)` конфигурация cron-расписания

`(sudo crontab -l 2>/dev/null; echo "* * * * * /usr/bin/python3 /home/a/PY/monitoring_final.py") | sudo crontab -`

`в)` [26-04-14-awesome-monitoring.log](./Monitoring_systems/awesome_monitoring/26-04-14-awesome-monitoring.log)


</details>

<details>
<summary>3. Система сбора логов Elastic Stack</summary>

## Задание 1

скриншот `docker ps` через `5 минут` после старта всех контейнеров (их должно быть 5):

![docker ps](./ELK/pngs/1.png)

скриншот интерфейса `kibana`:


![kibana](./ELK/pngs/2.png)



## Задание 2


![kibana logs](./ELK/pngs/3.png)


</details>
</details>

<details>
<summary>4. Платформа мониторинга Sentry</summary>

## Задание 1


![sentry0](./Sentry/pngs/0.png)

## Задание 2

[sample_sentry_script](Sentry/py_sentry/sentry_homework.py)

![sentry1](./Sentry/pngs/1.png)

## Задание 3


![sentry2](./Sentry/pngs/2.png)

## Задание повышенной сложности


[awesome_monitoring_sentry_script](Sentry/py_sentry/sentry_monitoring.py)
![sentry3](./Sentry/pngs/3.png)

</details>



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

# Kubernetes: основы, применение и администрирование

<details>
<summary>1. Kubernetes. Причины появления. Команда kubectl</summary>

# Скриншот дашборда

![](k8s-kubectl/pngs/1.png)

# Вывод комманд `kubectl get nodes`

![](k8s-kubectl/pngs/2.png)


</details>


<details>
<summary>2. Базовые объекты K8S</summary>

# Скриншот `kubectl port-forward service, pod` и  `kubectl get pods`

![](k8s-base-obj/pngs/1.png)


</details>



<details>


<summary>3. Запуск приложений в K8S</summary>

# Задание 1. Создание Deployment и обеспечение доступа к репликам приложения из другого Pod


## Создание Deployment, состоящего из двух контейнеров — nginx и multitool, yaml работающего конфига.  Увеличеник реплик до 2 +  количество подов до и после масштабирования.

![](k8s-app-run/pngs/1.png)

[nginx_multitool.yaml](k8s-app-run/nginx_multitool.yaml)


## Создание Service, который обеспечит доступ до реплик приложений из п.1.


![](k8s-app-run/pngs/2-1.png)

## Создание отдельного Pod с приложением multitool и убедиться с помощью curl, что из пода есть доступ до приложений из п.1.

![](k8s-app-run/pngs/2.png)

![](k8s-app-run/pngs/3.png)


# Задание 2. Создание Deployment и обеспечение  старта основного контейнера при выполнении условий

[nginx-init-container](k8s-app-run/nginx_runs_after_svc.yaml)

## Cостояние пода до запуска сервиса

![](k8s-app-run/pngs/4.png)

## Состояние пода после запуска сервиса


![](k8s-app-run/pngs/5.png)


</details>

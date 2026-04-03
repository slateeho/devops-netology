# Система управления конфигурациями

<details>
<summary>1. Введение в Ansible</summary>

# Основная часть

![](Ansible_intro/pngs/main_1.png)
![](Ansible_intro/pngs/main_2.png)
![](Ansible_intro/pngs/main_3.png)
![](Ansible_intro/pngs/main_4.png)

# Необязательная часть

- [Скрипт на bash](./Ansible_intro/additional_task/install_python_logged.sh)
- [Скрипт на Python](./Ansible_intro/additional_task/install_python_logged.py)

</details>

<details>

<summary>2. Работа с Playbook </summary>

# Основная часть

![](Ansible_playbook/pngs/1.png)

![](Ansible_playbook/pngs/2.png)

![](Ansible_playbook/pngs/3.png)

[README.md по ролям `Clickhouse` и  `Vector`](Ansible_playbook/main_task/README.md)


</details>

</details>

<details>

<summary>3. Использование Ansible</summary>

# Основная часть

[README.md по ролям `Clickhouse` + `Lighthouse` и `Vector`](Ansible_use/main_task/README.md)

[08-ansible-03-yandex tag](https://github.com/slateeho/devops-netology/releases/tag/08-ansible-03-yandex)


</details>

<details>
<summary>4. Работа с Roles</summary>

# Основная часть

[README.md по ролям `Clickhouse` + `Lighthouse` и `Vector`](Ansible_roles/main_task/README.md)

Результат выполнения `molecule test`:

![](Ansible_roles/main_task/jpgs/1.jpg)
![](Ansible_roles/main_task/jpgs/2.jpg)

[v1.0.3](https://github.com/slateeho/devops-netology/releases/tag/v1.0.3)


[v1.0.4](https://github.com/slateeho/devops-netology/releases/tag/v1.0.4)
</details>

</details>

<details>
<summary>5. Тестирование Roles</summary>

# Основная часть

[README.md по ролям `Clickhouse` + `Lighthouse` и `Vector`](Ansible_roles/main_task/README.md)

Результат выполнения `molecule converge`:

![](Ansible_molecule/main_task/pngs/1.png)

Результат выполнения `molecule idempotence`:

![](Ansible_molecule/main_task/pngs/2.png)

Результат выполнения `molecule verify`:

![](Ansible_molecule/main_task/pngs/2.png)

[v1.0.5](https://github.com/slateeho/devops-netology/releases/tag/v1.0.5)

Результат выполнения `tox -r`:

![](Ansible_molecule/main_task/pngs/4.png)

[v1.0.6](https://github.com/slateeho/devops-netology/releases/tag/v1.0.6)

</details>

<details>
<summary>6. Создание собственных модулей</summary>

`Обязатеьная часть`

[README.md по модулю `anyhostupload`](Ansible_modules/README.md)


![](Ansible_modules/main_task/pngs/1.png)
---
![](Ansible_modules/main_task/pngs/2.png)
---
![](Ansible_modules/main_task/pngs/3.png)
---
![](Ansible_modules/main_task/pngs/4.png)


`Необязательная часть`

![](Ansible_modules/add_task/pngs/1.png)
---
![](Ansible_modules/add_task/pngs/2.png)

[README.md по модулю `yc_vmm`](Ansible_modules/add_task/README.md)

Ansible Galaxy:

```shell
ansible-galaxy collection install slateeho.anyhostupload
ansible-galaxy collection install slateeho.yc_instance
ansible-galaxy collection install slateeho.infrastructure
```

</details>

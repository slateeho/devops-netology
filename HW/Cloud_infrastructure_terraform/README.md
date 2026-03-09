# Облачная инфраструктура. Terraform

<details>
<summary>1. Введение в Terraform</summary>

## Задание 1

[Директория с main.tf](terraform_intro/)

![Введение в Terraform](terraform_intro/1.png)

Согласно этому [.gitignore](https://raw.githubusercontent.com/netology-code/ter-homeworks/4730505f991c173ff42f44d7cffaa7366041e2f7/01/src/.gitignore), в файле под названием `personal.auto.tfvars` допустимо сохранить личную, секретную информацию (логины, пароли, ключи, токены и т.д).

Поскольку в раскомментированном блоке кода `main.tf` содержится тип ресурса без указания его наименования, а  также неверно поименованный ресурс.

![Введение в Terraform](terraform_intro/2.png)

Опасность -auto-approve заключается

- при добавлении новых ресурсов отсутствие плана не позволяет понять, что происходит удаление и пересоздание других ресурсов, приведет к потере доступности ресурса (опасно наличие записи will be replaced)
- при планировании наглядно отображается что будет destroy, и create
- не отображаются обновления ресурсов, которые были внесены до этого
- вероятность частичного создания инфраструктуры
- возникновение ошибок при наличии любых интерактивных скриптов (например, *.expect) (требующих взаимодействия с пользователем через терминал)

![Введение в Terraform](terraform_intro/3.png)

Лучшими практиками при выполнении plan \ apply в разных папках\окружениях и т.п. будет обеспечение консистентности хранилища провайдеров\версий .terraform.lock.hcl путем принудительного указания `terraform init -lockfile=readonly` как перед `terraform plan` (или, лучше `terraform plan -out=tfplan`) так и перед  `terraform apply`, в том числе и при использовании `-auto-approve`.

Содержимое файла terraform.tfstate:

```json
{
  "version": 4,w
  "terraform_version": "1.12.1",
  "serial": 100,
  "lineage": "955ce0e9-a08d-ffdd-4be5-1a507e124360",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
При удалении ресурсов docker image будет сохраняться локально, поскольку "keep_locally = true", а при указании обратного - удаляться, что следует из описания ресурса docker провайдера  `docker_image:

`• keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation.`

## Задание 2

Проверка Env в remote docker context на созданной ВМ:

![Введение в Terraform](terraform_intro/4.png)

## Задание 3

Opentofu init \ apply в yandex и docker remote директориях:

![Введение в Terraform](terraform_intro/5.png)
</details>

<details>
<summary>02. Основы Terraform. Yandex Cloud</summary>

## Задание 1

В коде были выявлены следующие синтаксические ошибки:

- неверно поименована переменная vms_ssh_root_keу, заменяется на требуемую в Задании 1 vms_ssh_public_root_key
- число ядер к 'yandex cloud' может быть минимально 2, при значении дробной части  процента (минимально 20%)
- необходимо указать  дефолтные значения yc cloud_id/fodler_id,
- неверный  platform_id ('standart-v4' -> 'standatd-v3')

Опции Preemptable = true и использьвание 20% CPU позволяет экономить денежные средства, уменьшая их потребление путем снижения как платы за CPU, так и позволяя автоматически выключать неиспользуемую виртуальную машину, снижая расход до нуля

![Основы в Terraform](terraform_basics/task_1/pngs/1.png)

![Основы в Terraform](terraform_basics/task_1/pngs/2.png)

## Задание 2-4

![Основы в Terraform](terraform_basics/task_1/pngs/3.png)

## Задание 5-6

Задание выполнено в коде папки `terraform_basics`

### Задание 7*

![Основы в Terraform](terraform_basics/task_1/pngs/4.png)

### Задание 8*

![Основы в Terraform](terraform_basics/task_1/pngs/8.png)

### Задание 9*

![Основы в Terraform](terraform_basics/task_1/pngs/9.png)

</details>

<details>
<summary>03. Управляющие конструкции в коде Terraform Основы Terraform.</summary>

### Задание 1

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/1.png)

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/2.png)

### Задания 2-4

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/4.png)


![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/4_1.png)

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/4.png)


### Заданиe 5*

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/5.png)


### Заданиe 5*

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/5.png)


### Заданиe 6*

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/6.png)


### Заданиe 7*

Решение находится в папке `terraform_control_constructs/terraform-03/task_7_asterisk`


### Заданиe 8*

Решение находится  в `terraform_control_constructs/task_6_asterisk/hosts.tftpl`

### Заданиe 9*

![Управляющие конструкции в Terraform](terraform_control_constructs/terraform-03/pngs/9.png)


</details>

<details>
<summary>Продвинутые методы работы с Terraform</summary>


### Задание 1


![Продвинутые методы работы с Terraform](terraform_advanced/pngs/1.png)

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/1-1.png)

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/1-2.png)

------

### Задание 2


![Продвинутые методы работы с Terraform](terraform_advanced/pngs/2-1.png)

[Terraform-docs/task_1/04/demonstration1/vms](terraform_advanced/task_1/04/demonstration1/vms/README.md)

### Задание 3

```shell
terraform state list
terraform state rm module.vpc_dev
terraform state rm module.analytics_vm
terraform state rm module.marketing_vm
terraform import 'module.vpc_dev.yandex_vpc_network.vpc_dev' enptj5q7du6mns1jrtp4
terraform import 'module.vpc_dev.yandex_vpc_subnet.vpc_dev["vpc_dev_a"]' e9b1mr8ethmbcrd0i0l8
terraform import 'module.vpc_dev.yandex_vpc_subnet.vpc_dev["vpc_dev_b"]' e2l7lm9dro2cl2u9fu8o
terraform import 'module.vpc_dev.yandex_vpc_security_group.vpc_dev' enpmlficq4197va4pqie
terraform import 'module.analytics_vm.yandex_compute_instance.vm[0]' fhmq3lbjlmr4mja5n1lb
terraform import 'module.marketing_vm.yandex_compute_instance.vm[0]' fhmhc8e9ark38egdfjir
terraform import 'module.marketing_vm.yandex_compute_instance.vm[1]' epd7cac0sh8vi0udkrf3
```
![Продвинутые методы работы с Terraform](terraform_advanced/pngs/3.png)


## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.


### Задание 4*

```HCL
# CHILD main.tf
data "yandex_client_config" "client" {}

resource "yandex_vpc_network" "vpc_dev" {
  name      = "vpc-${var.env_name}"
  folder_id = data.yandex_client_config.client.folder_id
}

resource "yandex_vpc_subnet" "vpc_dev" {
  for_each       = var.subnets
  name           = "vpc_${var.env_name}-${each.key}"
  folder_id      = data.yandex_client_config.client.folder_id
  network_id     = yandex_vpc_network.vpc_dev.id
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.v4_cidr_blocks]
}

resource "yandex_vpc_security_group" "vpc_dev" {
  name       = "vpc_${var.env_name}-sg"
  network_id = yandex_vpc_network.vpc_dev.id
  folder_id  = data.yandex_client_config.client.folder_id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
```

```HCL
# parent child.tf
module "vpc_dev" {
  source = "./vpc_dev"

  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  default_zone = var.default_zone
  env_name     = "develop"
}

module "vpc_prod" {
  source = "./vpc_dev"

  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  default_zone = var.default_zone
  env_name     = "production"
}

output "network_name" {
  value = module.vpc_dev.network_name
}

output "network_id" {
  value = module.vpc_dev.network_id
}

output "subnet_zone" {
  value = module.vpc_dev.subnet_zone
}

output "subnet_v4_cidr_blocks" {
  value = module.vpc_dev.subnet_v4_cidr_blocks
}

output "subnet_ids" {
  value = module.vpc_dev.subnet_ids
}
```
`terraform plan`

```
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=19ab2dda820c530557c6feb2be1fa6ac345bbf75bfc7e1a5f54a7769f4bcc7f3]
data.aws_ssm_parameter.token: Reading...
module.vpc_prod.data.aws_ssm_parameter.token: Reading...
module.vpc_dev.data.aws_ssm_parameter.token: Reading...
module.vpc_dev.data.aws_ssm_parameter.token: Read complete after 0s [id=/yandex/yc-oauth-token]
data.aws_ssm_parameter.token: Read complete after 0s [id=/yandex/yc-oauth-token]
module.vpc_prod.data.aws_ssm_parameter.token: Read complete after 0s [id=/yandex/yc-oauth-token]
module.analytics_vm.data.yandex_compute_image.my_image: Reading...
module.marketing_vm.data.yandex_compute_image.my_image: Reading...
module.vpc_dev.data.yandex_client_config.client: Reading...
module.vpc_dev.data.yandex_client_config.client: Read complete after 0s [id=2748697577]
module.vpc_prod.data.yandex_client_config.client: Reading...
module.vpc_prod.data.yandex_client_config.client: Read complete after 0s [id=2748697577]
module.marketing_vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd835npr436ep5g144gq]
module.analytics_vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd835npr436ep5g144gq]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.hosts_ini will be created
  + resource "local_file" "hosts_ini" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
   ...
Changes to Outputs:
  + analytics_vm_instances = [
      + {
          + external_ip = (known after apply)
          + fqdn        = (known after apply)
          + name        = "stage-web-stage-0"
        },
    ]
  + marketing_vm_instances = [
      + {
          + external_ip = (known after apply)
          + fqdn        = (known after apply)
          + name        = "develop-webs-0"
        },
      + {
          + external_ip = (known after apply)
          + fqdn        = (known after apply)
          + name        = "develop-webs-1"
        },
    ]
  + network_id             = (known after apply)
  + network_name           = "vpc-develop"
  + out                    = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
  + subnet_ids             = [
      + (known after apply),
      + (known after apply),
    ]
  + subnet_v4_cidr_blocks  = {
      + vpc_dev_a = [
          + "10.0.1.0/24",
        ]
      + vpc_dev_b = [
          + "10.0.3.0/24",
        ]
    }
  + subnet_zone            = {
      + vpc_dev_a = "ru-central1-a"
      + vpc_dev_b = "ru-central1-b"
    }
  ```

```shell
$ yc compute instance list --format json | jq -r '.[] | "\(.name) \(.zone_id) \(.id) \(.status)"'
develop-webs-1 ru-central1-b epd9bfueiuke8rr931cf RUNNING
stage-web-stage-0 ru-central1-a fhmfhpnh3jk398dbisrv RUNNING
develop-webs-0 ru-central1-a fhmhkl0si359stsebd16 RUNNING
```
### Задание 5*

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/5.png)

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/5-1.png)

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/5-2.png)

### Задание 6*

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/6.png)

### Задание 7*

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/7.png)

### Задание 8*

![Продвинутые методы работы с Terraform](terraform_advanced/pngs/8.png)

</details>


<details>
<summary>05. Использование Terraform в команде</summary>

### Задание 1

1. Возьмите код:
- при проверке [ДЗ к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/src) checkov и tflint уязвимостей или предупреждений выявлено не было.
- при [демо к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) выявлено следующее:

### Проверка TFLint

| Тип ошибки | Описание | Файл/строка | Статус |
|---|---|---|---|
| terraform_required_providers | Отсутствует ограничение версии для провайдера "yandex" в `required_providers` | providers.tf:3 |  Предупреждение |
| terraform_unused_declarations | Переменная "vms_ssh_root_key" объявлена, но не используется | variables.tf:36 |  Исправляемо |
| terraform_unused_declarations | Переменная "vm_web_name" объявлена, но не используется | variables.tf:43 |  Исправляемо |
| terraform_unused_declarations | Переменная "vm_db_name" объявлена, но не используется | variables.tf:50 |  Исправляемо |

### Проверка Checkov (демонстрация 4)

| Тип проверки | Описание | Ресурс | Файл/строка | Статус |
|---|---|---|---|---|
| CKV_TF_1 | Убедитесь, что источники модулей Terraform используют хеш коммита | test-vm | vms/main.tf:22-43 |  Ошибка |
| CKV_TF_2 | Убедитесь, что источники модулей Terraform используют тег с номером версии | test-vm | vms/main.tf:22-43 |  Ошибка |
| CKV_TF_1 | Убедитесь, что источники модулей Terraform используют хеш коммита | example-vm | vms/main.tf:45-61 |  Ошибка |
| CKV_TF_2 | Убедитесь, что источники модулей Terraform используют тег с номером версии | example-vm | vms/main.tf:45-61 | Ошибка |

**Проблема:** Модули используют `?ref=main` вместо конкретного хеша коммита или версии тега.

### Задание 2
1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Настройте remote state с встроенными блокировками:
   - Создайте S3 bucket в Yandex Cloud для хранения state (если еще не создан)
   - Создайте service account с правами на чтение/запись в bucket
   - Настройте backend в providers.tf с использованием нового механизма блокировок:


```terraform {
       required_version = "~>1.12.0"

       backend "s3" {
         bucket  = "ваш-bucket-name"
         key     = "terraform.tfstate"
         region  = "ru-central1"

         # Встроенный механизм блокировок (Terraform >= 1.6)
         # Не требует отдельной базы данных!
         use_lockfile = true

         endpoints = {
           s3 = "https://storage.yandexcloud.net"
         }

         skip_region_validation      = true
         skip_credentials_validation = true
         skip_requesting_account_id  = true
yc compute instance list
         skip_s3_checksum            = true
       }
}
     ```
   - Выполните `terraform init -migrate-state` для миграции state в S3
   - Предоставьте скриншоты процесса настройки и миграции
3. Закоммитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к state (блокировка должна сработать автоматически).
6. Принудительно разблокируйте state командой `terraform force-unlock <LOCK_ID>`. Пришлите команду и вывод.

**Примечание:** В Terraform >= 1.6 появился встроенный механизм бл:окировок через `use_lockfile = true`.
Это упрощает настройку - больше не нужно создавать отдельную базу данных (YDB в режиме DynamoDB) для хранения блокировок.
Lock-файл создается автоматически в том же S3 bucket рядом с state-файлом с именем `<key>.lock.info`.

------
### Задание 3

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'.
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

------
### Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console.

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Их выполнение поможет глубже разобраться в материале.
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.
------
### Задание 5*
1. Напишите переменные с валидацией:

- type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
- type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```
------
### Задание 6*

1. Настройте любую известную вам CI/CD-систему. Если вы ещё не знакомы с CI/CD-системами, настоятельно рекомендуем вернуться к этому заданию после изучения Jenkins/Teamcity/Gitlab.
2. Скачайте с её помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.
3. Уничтожьте инфраструктуру тем же способом.

------
### Задание 7*
1. Настройте отдельный terraform root модуль, который будет создавать инфраструктуру для remote state:
   - S3 bucket для tfstate с версионированием
   - Сервисный аккаунт с необходимыми правами (storage.editor)
   - Static access key для сервисного аккаунта
2. Output должен содержать:
   - Имя bucket
   - Access key ID и Secret key (sensitive)
   - Пример конфигурации backend для использования
3. После создания инфраструктуры используйте outputs для настройки backend в основном проекте.

**Примечание:** Так как используется `use_lockfile = true`, создавать YDB/DynamoDB больше не требуется.
Блокировки реализованы встроенным механизмом Terraform и хранятся в том же S3 bucket.

### Правила приёма работы

Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-05.

В качестве результата прикрепите ссылку на ветку terraform-05 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки.

</details>


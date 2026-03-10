#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-${local.subnets["vpc_dev_a"].zone}"
  zone           = local.subnets["vpc_dev_a"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [local.subnets["vpc_dev_a"].v4_cidr_blocks]
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-${local.subnets["vpc_dev_b"].zone}"
  zone           = local.subnets["vpc_dev_b"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [local.subnets["vpc_dev_b"].v4_cidr_blocks]
}

module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=c59b04f9428f89fdce7b2e2fbccdd284c6f9f6a2"
  env_name       = "develop" 
  network_id     = module.vpc_dev.network_id
  subnet_zones   = values(module.vpc_dev.subnet_zone)
  subnet_ids     = values(module.vpc_dev.subnet_ids)
  instance_name  = "webs"
  instance_count = 2
  image_family   = "ubuntu-2204-lts"
  public_ip      = true
  preemptible    = true

  labels = { 
    owner   = "lao"
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${trimspace(file("/home/a/.ato4ka/security/.ssh/id_ed25519.pub"))}"
  }
}

module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=c59b04f9428f89fdce7b2e2fbccdd284c6f9f6a2"
  env_name       = "stage"
  network_id     = module.vpc_dev.network_id
  subnet_zones   = [module.vpc_dev.subnet_zone["vpc_dev_a"]]
  subnet_ids     = [module.vpc_dev.subnet_ids["vpc_dev_a"]]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2204-lts"
  public_ip      = true
  preemptible    = true

  labels = { 
    owner   = "lao"
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${trimspace(file("/home/a/.ato4ka/security/.ssh/id_ed25519.pub"))}"
  }
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    public_key = local.public_key
  }
}

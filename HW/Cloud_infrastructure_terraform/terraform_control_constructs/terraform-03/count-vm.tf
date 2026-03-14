# Количество виртуальных машин с заданным именем web-*

locals {
  web_ssh_key     = file(var.common["ssh_key_pub"])
  db_ssh_key      = file(var.common["ssh_key_pub"])
  web_private_key = var.common["ssh_key"]
  db_private_key  = var.common["ssh_key"]
  ansible_user    = var.common["ansible_user"]
}

resource "yandex_compute_instance" "web" { 
  count      = 2
  depends_on = [module.child]
  name       = "web-${count.index + 1}"
  platform_id   = var.vm_web["platform_id"]
  zone          = var.vm_web["zone"]
  
  resources {
    cores         = var.vm_web["cores"]
    memory        = var.vm_web["memory"]
    core_fraction = var.vm_web["core_fraction"]
    
      }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu_image.id
        size     = 10
        type     = "network-hdd"
      }
    }

  scheduling_policy {
    preemptible = var.vm_web["preemptible"]

  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.web_ssh_key}"
  }
}


data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}



module "child" {
  source            = "./task_1-2"
  subnet_id         = yandex_vpc_subnet.develop.id
  security_group_id = yandex_vpc_security_group.example.id
}

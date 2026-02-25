# Количество виртуальных машин с заданным именем web-*

variable "public_subnets_per_vpc" {
  description = "Number of public subnets. Maximum of 16."
  type        = number
  default     = 3
}

variable "private_subnet_cidr_blocks_per_vpc" {
  description = "Number of private subnets. Maximum of 16."
  type        = number
  default     = 3
}


locals {
  web_ssh_key     = file("~/.ssh/id_rsa.pub")
  db_ssh_key      = file("~/.ssh/id_rsa.pub")
  web_private_key = "~/.ssh/id_rsa"
  db_private_key  = "~/.ssh/id_rsa"
  ansible_user    = "ubuntu"
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
        image_id = data.yandex_compute_image.my_image.id
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


data "yandex_compute_image" "my_image" {
  family = "ubuntu-2204-lts"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24",
    "10.0.16.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
    "10.0.109.0/24",
    "10.0.110.0/24",
    "10.0.111.0/24",
    "10.0.112.0/24",
    "10.0.113.0/24",
    "10.0.114.0/24",
    "10.0.115.0/24",
    "10.0.116.0/24"
  ]
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



variable "vm_web" {
  type = map(any)
  default = {
    platform_id     = "standard-v3"
    zone            = "ru-central1-a"
    cores           = 2
    memory          = 1
    core_fraction   = 20
    preemptible     = true
  }
  description = "DB VM configuration"
}



module "child" {
  source            = "./task_1-2"
  subnet_id         = yandex_vpc_subnet.develop.id
  security_group_id = yandex_vpc_security_group.example.id
}

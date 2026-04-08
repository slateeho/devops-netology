###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
variable "vm_web_family" {
  type = string
  default = "debian-12"
}
variable "debian_vm_config" {
  type = list(object({
    name          = string
    platform_id   = string
    zone          = string
    nat_ip        = bool
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    name_disk     = string
    hdd_type      = string
  }))

  default = [
    {
      name          = "debian-2"
      platform_id   = "standard-v3"
      zone          = "ru-central1-a"
      nat_ip        = true
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      name_disk     = "HDD"
      hdd_type      = "network-hdd"
    },
    {
      name          = "debian-3"
      platform_id   = "standard-v3"
      zone          = "ru-central1-a"
      nat_ip        = true
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 15
      name_disk     = "HDD"
      hdd_type      = "network-hdd"
    }
  ]
}

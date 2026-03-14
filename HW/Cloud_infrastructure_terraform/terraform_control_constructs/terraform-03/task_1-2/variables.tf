variable "subnet_id" {
  description = "Subnet ID from parent"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID from parent"
  type        = string
}

variable "web_instance_names" {
  description = "Web instance names from parent"
  type        = list(string)
  default     = []
}

variable "db_instances" {
  description = "Database instances data from parent"
  type = list(object({
    name = string
    nat_ip = string
    fqdn = string
  }))
  default = []
}

variable "storage_instance" {
  description = "Storage instance data from parent"
  type = object({
    name = string
    nat_ip = string
    fqdn = string
  })
  default = {
    name = ""
    nat_ip = ""
    fqdn = ""
  }
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 4
      ram         = 4
      disk_volume = 11
    }
  ]
}

variable "vm_db" {
  type = map(any)
  default = {
    platform_id     = "standard-v3"
    zone            = "ru-central1-a"
    memory          = 1
    core_fraction   = 20
    preemptible     = true
  }
  description = "DB VM configuration"
}

variable "metadata" {
  type = map(any)
  default = {
    serial-port-enable = 1
  }
  description = "Metadata for all VMs"
}

variable "count_yc_disks" {
  description = "Number of YC disks"
  type        = number
  default     = 3
}

variable "vm_type" {
  description = "Backend VM type"
  type        = string
  default     = "storage"
}

locals {
  vms = { for vm in var.each_vm : vm.vm_name => vm }
  db_ssh_key = file("~/.ssh/id_rsa.pub")
  db_private_key = "~/.ssh/id_rsa"
  ansible_user = "ubuntu"
}

data "yandex_compute_image" "my_image" {
  family = "ubuntu-2204-lts"
}

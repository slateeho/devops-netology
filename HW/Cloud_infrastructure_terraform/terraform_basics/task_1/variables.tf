###cloud vars

variable "cloud_id" {
  type        = string
  default     = "b1g2lqlbrsjon6qhlsso"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1ghqjh9j50gl3bqspbv"
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
  description = "VPC network & subnet name"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = ""
  description = "ssh-keygen -t ed25519"
}

#variable "vms_ssh_public_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmZGX3w3LwoW4Pr0FKxl3s8L2RMC+e+w2+5ghVQo8Ga a@aser"
##  description = "ssh-keygen -t ed25519"
#}

#variable "vms_db_ssh_public_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9h0xZaOKOxCqeMA6KUraXjGCmVnWGfAkuy3S/9FUke a@aser"
#  description = "ssh-keygen -t ed25519 for db vm"
#}

###vm_web vars (UNUSED - using vm_web map instead)
# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
#   description = "VM instance name"
# }

# variable "vm_web_platform_id" {
#   type        = string
#   default     = "standard-v3"
#   description = "VM platform ID"
# }

# variable "vm_web_cores" {
#   type        = number
#   default     = 2
#   description = "Number of CPU cores (min 2)"
# }

# variable "vm_web_memory" {
#   type        = number
#   default     = 1
#   description = "Memory in GB"
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   default     = 20
#   description = "CPU fraction % (min 20)"
# }

# variable "vm_web_image_family" {
#   type        = string
#   default     = "ubuntu-2004-lts"
#   description = "image family"
# }

# variable "vm_web_preemptible" {
#   type        = bool
#   default     = true
#   description = "preemptible is true"
# }

# variable "vm_web_zone" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "Zone for web VM"
# }

###vm_web variable

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
  description = "Web VM configuration"
}

###vm_db variable
variable "vm_db" {
  type = map(any)
  default = {
    platform_id     = "standard-v3"
    zone            = "ru-central1-b"
    cores           = 2
    memory          = 2
    core_fraction   = 20
    preemptible     = true
  }
  description = "DB VM configuration"
}

###metadata variable
variable "metadata" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmZGX3w3LwoW4Pr0FKxl3s8L2RMC+e+w2+5ghVQo8Ga a@aser"
  }
  description = "Metadata for all VMs"
}


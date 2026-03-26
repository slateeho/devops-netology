variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "public_key" {
  type = string
}

variable "private_key" {
  type = string
}

variable "vm_user" {
  type = string
}

variable "image_id" {
  type = string
}

variable "db_vm_count" {
  type    = number
  default = 1
}

variable "db_vm_name" {
  type    = string
  default = "db-vm"
}

variable "db_cores" {
  type    = number
  default = 2
}

variable "db_memory" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "db_root_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}


variable "yc_token" {
  type = string
}

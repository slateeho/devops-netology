variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "network_id" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type = string
}

variable "mysql_version" {
  type = string
}

variable "resource_preset_id" {
  type = string
}

variable "disk_type_id" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "maintenance_type" {
  type = string
}

variable "maintenance_day" {
  type = string
}

variable "maintenance_hour" {
  type = number
}

variable "ha" {
  type    = bool
  default = true
}

variable "host_zone_dynamic" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "database_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "user_password" {
  type      = string
  sensitive = true
}

variable "user_permissions" {
  type = list(object({
    database_name = string
    roles         = list(string)
  }))
}

variable "max_questions_per_hour" {
  type    = number
  default = 0
}

variable "max_updates_per_hour" {
  type    = number
  default = 0
}

variable "max_connections_per_hour" {
  type    = number
  default = 0
}

variable "max_user_connections" {
  type    = number
  default = 0
}

variable "global_permissions" {
  type    = list(string)
  default = []
}

variable "authentication_plugin" {
  type    = string
  default = "SHA256_PASSWORD"
}

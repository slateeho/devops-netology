variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Folder ID"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default zone"
}


variable "vm_user" {
  type        = string
  default     = "debian"
  description = "SSH user for VM"
}

variable "database_name" {
  type        = string
  default     = "app_db"
  description = "Database name"
}

variable "user_name" {
  type        = string
  default     = "app_user"
  description = "Database user name"
}

variable "os_distro" {
  type        = string
  default     = "debian"
  description = "OS distribution for Docker repo"
}

variable "service_account_id" {
  type        = string
  default     = "ajev6no0d04buotbn43i"
  description = "Service account ID for Lockbox and S3 remote state access"
}


variable "yc_token" {
  type = string
}

variable "dns_members" {
  description = "IAM members allowed to view/manage DNS zone"
  type        = list(string)
  default     = []
}


variable "dns_zone" {
  type = string
}

variable "dns_name" {
  type    = string
  default = "@"
}

variable "db_image_id" {
  type        = string
  description = "Image ID for DB VM"
  default     = "fd8e9t6fpgi13oh7q39f"
}

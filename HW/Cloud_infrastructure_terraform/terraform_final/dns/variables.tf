variable "name" {
  type = string
}

variable "zone" {
  type = string
}

variable "folder_id" {
  type    = string
  default = null
}

variable "is_public" {
  type    = bool
  default = true
}

variable "private_networks" {
  type    = list(string)
  default = []
}

variable "web_vm_public_ip" {
  type = string
}

variable "dns_members" {
  description = "IAM members allowed to view/manage DNS zone"
  type        = list(string)
  default     = []
}

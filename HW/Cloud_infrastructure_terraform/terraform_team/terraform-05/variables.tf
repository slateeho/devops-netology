###cloud vars

locals {
  public_key  = trimspace(file("/home/a/.ato4ka/security/.ssh/id_ed25519.pub"))
  private_key = "/home/a/.ato4ka/security/.ssh/id_ed25519"
  cloud_init  = yamldecode(file("${path.module}/cloud-init.yml"))
  username    = local.cloud_init.users[0].name
  
  s3_keys = jsondecode(file("${path.module}/s3_keys.json"))
  
  marketing_vm_flat = [
    for i, v in module.marketing_vm.all : {
      name        = v.name
      fqdn        = module.marketing_vm.fqdn[i]
      external_ip = module.marketing_vm.external_ip_address[i]
    }
  ]

  analytics_vm_flat = [
    for i, v in module.analytics_vm.all : {
      name        = v.name
      fqdn        = module.analytics_vm.fqdn[i]
      external_ip = module.analytics_vm.external_ip_address[i]
    }
  ]
}

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

variable "ha" {
  type        = bool
  default     = false
  description = "Enable high availability"
}

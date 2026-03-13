###cloud vars

locals {
  public_key  = trimspace(file("${path.module}/id_ed25519.pub"))
  private_key = "${path.module}/id_ed25519"
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

variable "s3_backend" {
  type = map(any)
  default = {
    bucket                      = "lao-ush244oz"
    key                         = "terraform.tfstate"
    region                      = "ru-central1"
    use_lockfile                = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

variable "yc_sync_sa" {
  type        = string
  default     = "s3-sync-sa"
  description = "Service account SA name"
}

variable "bucket_name" {
  type        = string
  default     = "lao-ush244oz"
  description = "TF remote STATE_BUCKET"
}

variable "public_key_content" {
  type        = string
  default     = ""
  description = "Public key content (optional, uses local file if empty)"
}

variable "private_key_path" {
  type        = string
  default     = ""
  description = "Private key path (optional, uses local file if empty)"
}

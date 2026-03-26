locals {
  subnets = {
    "vpc_dev_a" = {
      zone           = "ru-central1-a"
      v4_cidr_blocks = "10.0.1.0/24"
    }
    "vpc_dev_b" = {
      zone           = "ru-central1-b"
      v4_cidr_blocks = "10.0.3.0/24"
    }
  }
}

module "vpc_dev" {
  source = "./vpc_dev"
  
  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  default_zone = var.default_zone
  env_name     = "develop"
  subnets      = local.subnets
}

module "db" {
  source = "./db"
  
  cloud_id          = var.cloud_id  
  folder_id         = var.folder_id
  yc_token          = var.yc_token
  default_zone      = var.default_zone
  network_id        = module.vpc_dev.network_id
  subnet_ids        = [
    module.vpc_dev.subnet_ids["vpc_dev_a"],
    module.vpc_dev.subnet_ids["vpc_dev_b"]
  ]
  security_group_id = module.vpc_dev.security_group_id
  
  public_key        = local.public_key
  private_key       = local.private_key
  vm_user           = var.vm_user

  image_id          = var.db_image_id 

  db_vm_count       = 1
  db_vm_name        = "db-vm"
  db_cores          = 2
  db_memory         = 2
  disk_size         = 20
  assign_public_ip  = true
  
  db_root_password  = random_password.db_password.result
  db_name           = var.database_name
  db_user           = var.user_name
  db_password       = random_password.db_password.result
}


module "dns" {
  source = "./dns"

  name      = var.dns_name
  zone      = var.dns_zone
  is_public = true

  web_vm_public_ip = yandex_compute_instance.web.network_interface[0].nat_ip_address
  dns_members      = var.dns_members
}

output "dns_urls" {
  description = "DNS endpoints"
  value = {
    root = "http://${module.dns.domain}:3000"
    www  = "http://www.${module.dns.domain}:3000"
    api  = "http://api.${module.dns.domain}:8080"
  }
}

output "network_name" {
  value = module.vpc_dev.network_name
}

output "network_id" {
  value = module.vpc_dev.network_id
}

output "subnet_zone" {
  value = module.vpc_dev.subnet_zone
}

output "subnet_v4_cidr_blocks" {
  value = module.vpc_dev.subnet_v4_cidr_blocks
}

output "subnet_ids" {
  value = module.vpc_dev.subnet_ids
}

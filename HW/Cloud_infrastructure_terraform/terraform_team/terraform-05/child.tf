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
  
  cloud_id               = var.cloud_id
  folder_id              = var.folder_id
  default_zone           = var.default_zone
  cluster_name           = "test"
  environment            = "PRESTABLE"
  network_id             = module.vpc_dev.network_id
  mysql_version          = "8.0"
  resource_preset_id     = "s2.micro"
  disk_type_id           = "network-ssd"
  disk_size              = 16
  maintenance_type       = "WEEKLY"
  maintenance_day        = "SAT"
  maintenance_hour       = 12
  ha                     = var.ha
  host_zone_dynamic      = "ru-central1-a"
  subnet_ids = [
    module.vpc_dev.subnet_ids["vpc_dev_a"],
    module.vpc_dev.subnet_ids["vpc_dev_b"]
  ]
  security_group_id      = module.vpc_dev.security_group_id
  assign_public_ip       = false
  database_name          = "test"
  user_name              = "app"
  user_password          = data.aws_ssm_parameter.db_password.value
  user_permissions       = [
    {
      database_name = "test"
      roles         = ["ALL"]
    }
  ]
  max_questions_per_hour   = 10
  max_updates_per_hour     = 20
  max_connections_per_hour = 30
  max_user_connections     = 40
  global_permissions       = ["PROCESS"]
  authentication_plugin    = "SHA256_PASSWORD"
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

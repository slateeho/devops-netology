locals {
  public_key  = trimspace(file("${path.module}/id_ed25519.pub"))
  private_key = trimspace(file("${path.module}/id_ed25519"))
}

# Generate random password for DB user
resource "random_password" "db_password" {
  length           = 24
  numeric          = true
  special          = true
  override_special = "!%&*()_-="
}

# Web VM
resource "yandex_compute_instance" "web" {
  name        = "web-vm"
  zone        = var.default_zone
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8e9t6fpgi13oh7q39f"
      size     = 20
    }
  }

  network_interface {
    subnet_id          = module.vpc_dev.subnet_ids["vpc_dev_a"]
    security_group_ids = [module.vpc_dev.security_group_id]
    nat                = true
    ipv4               = true
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      vm_user              = var.vm_user
      folder_id            = var.folder_id
      public_key           = local.public_key
      private_key          = local.private_key
      os_distro            = var.os_distro
      db_cluster_host      = module.db.db_primary_ip
      db_cluster_id        = module.db.db_primary_ip
      db_database_name     = var.database_name
      db_user_name         = var.user_name
      db_user_password     = random_password.db_password.result
      lockbox_secret_id    = yandex_lockbox_secret.db_credentials.id
      yc_token             = var.yc_token
    })
    ssh-keys  = "${var.vm_user}:${local.public_key}"
  }

  depends_on = [module.db]
}

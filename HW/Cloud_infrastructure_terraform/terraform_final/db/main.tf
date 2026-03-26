resource "yandex_compute_instance" "db_vm" {
  count       = var.db_vm_count
  name        = "${var.db_vm_name}-${count.index + 1}"
  zone        = var.default_zone
  platform_id = "standard-v3"

  resources {
    cores  = var.db_cores
    memory = var.db_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id          = var.subnet_ids[count.index % length(var.subnet_ids)]
    security_group_ids = [var.security_group_id]
    nat                = var.assign_public_ip
    ipv4               = true
  }

  metadata = {
    user-data = templatefile("${path.module}/../cloud-init-db.yaml", {
      vm_user          = var.vm_user
      public_key       = var.public_key
      db_root_password = var.db_root_password
      db_name          = var.db_name
      db_user          = var.db_user
      db_password      = var.db_password
      yc_token         = var.yc_token  
    })
    ssh-keys = "${var.vm_user}:${var.public_key}"
  }
}

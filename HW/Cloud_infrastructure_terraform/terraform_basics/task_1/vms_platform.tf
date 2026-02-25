###develop_db subnet
resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

###db compute instance
resource "yandex_compute_instance" "netology-develop-platform-db" {
  name                     = local.vm_db_name
  platform_id              = var.vm_db["platform_id"]
  zone                     = var.vm_db["zone"]
  allow_stopping_for_update = true
  
  resources {
    cores         = var.vm_db["cores"]
    memory        = var.vm_db["memory"]
    core_fraction = var.vm_db["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = var.vm_db["preemptible"]
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = false
  }
  metadata = var.metadata
}

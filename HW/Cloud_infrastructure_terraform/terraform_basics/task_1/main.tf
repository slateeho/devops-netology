resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

###web compute instance
resource "yandex_compute_instance" "platform_web" {
  name                     = local.vm_web_name
  platform_id              = var.vm_web["platform_id"]
  zone                     = var.vm_web["zone"]
  allow_stopping_for_update = true
  
  resources {
    cores         = var.vm_web["cores"]
    memory        = var.vm_web["memory"]
    core_fraction = var.vm_web["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = var.vm_web["preemptible"]
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = var.metadata
}

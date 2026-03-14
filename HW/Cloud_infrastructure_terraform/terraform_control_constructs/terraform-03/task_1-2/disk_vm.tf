resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name  = "disk-${count.index}"
  type  = "network-hdd"
  zone  = "ru-central1-a"
  size  = 1

  labels = {
    environment = "test-${count.index}"
  }
}

resource "yandex_compute_instance" "storage" {
  depends_on = [yandex_compute_instance.db]
  name        = "storage"
  hostname    = "${[for vm in var.each_vm : vm.vm_name][0]}-${var.vm_type}"
  platform_id = var.vm_db["platform_id"]
  zone        = var.vm_db["zone"]

  resources {
    cores         = var.each_vm[0].cpu
    memory        = var.each_vm[0].ram
    core_fraction = var.vm_db["core_fraction"]
  }

  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size = var.each_vm[0].disk_volume
      type = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = var.vm_db["preemptible"]
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = true
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.db_ssh_key}"
  }
}

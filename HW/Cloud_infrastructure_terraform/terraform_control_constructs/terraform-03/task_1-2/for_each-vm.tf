# https://support.hashicorp.com/hc/en-us/articles/47291930108563-Preventing-Massive-Re-Creates-Caused-by-for-each-Key-Drift-in-AzureRM-VM-Modules

resource "yandex_compute_instance" "db" { 
  for_each = local.vms  
  name          = each.value.vm_name
  platform_id   = var.vm_db["platform_id"]
  zone          = var.vm_db["zone"]
  
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vm_db["core_fraction"]
  }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.my_image.id
        size     = each.value.disk_volume
        type     = "network-hdd"
      }
    }

  scheduling_policy {
    preemptible = var.vm_db["preemptible"]
  }

  network_interface {
    subnet_id          = var.subnet_id
    security_group_ids = [var.security_group_id]
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.db_ssh_key}"
  }
}
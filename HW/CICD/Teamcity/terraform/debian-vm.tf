resource "yandex_compute_instance" "debian" {
  for_each = { for vm in var.debian_vm_config : vm.name => vm }

  name        = each.value.name
  hostname    = each.value.name
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian.id
      size     = each.value.hdd_size
      type     = each.value.hdd_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat_ip
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "debian:${local.ssh_public_key}"
  }
}

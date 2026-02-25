resource "yandex_vpc_network" "main" {
  name        = "simple-network"
  description = "Simple network for VM deployment"
}

resource "yandex_vpc_subnet" "main" {
  name           = "simple-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_compute_instance" "vm" {
  name = "simple-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2

  }

  boot_disk {
    initialize_params {
      image_id = "fd8miiisblcuktpjr6sc"
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.main.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.vm_sg.id]
  }




  metadata = {
    ssh-keys  = "debian:${file("/home/a/.ato4ka/security/.ssh/yandex/yandex.pub")}"
    user-data = file("${path.module}/cloud-init.yaml")
  }
}

output "vm_external_ip" {
  description = "External IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh://debian@${yandex_compute_instance.vm.network_interface.0.nat_ip_address}:22"
}


output "docker_host" {
  value = "ssh://debian@${yandex_compute_instance.vm.network_interface.0.nat_ip_address}:22"
}

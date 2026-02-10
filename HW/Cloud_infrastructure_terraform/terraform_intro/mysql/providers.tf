terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "docker" {
  host     = "ssh://debian@${yandex_compute_instance.vm.network_interface.0.nat_ip_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

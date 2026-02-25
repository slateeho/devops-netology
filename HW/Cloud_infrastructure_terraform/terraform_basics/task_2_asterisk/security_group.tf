# Security group with all required ports
resource "yandex_vpc_security_group" "vm_sg" {
  name       = "vm-security-group"
  network_id = yandex_vpc_network.main.id

  # SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL
  ingress {
    protocol       = "TCP"
    port           = 3306
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker API (unencrypted)
  ingress {
    protocol       = "TCP"
    port           = 2375
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker API (encrypted)
  ingress {
    protocol       = "TCP"
    port           = 2376
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_network" "vpc_dev" {
  name      = "vpc-${var.env_name}"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "vpc_dev" {
  for_each       = var.subnets
  name           = "vpc_${var.env_name}-${each.key}"
  folder_id      = var.folder_id
  network_id     = yandex_vpc_network.vpc_dev.id
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.v4_cidr_blocks]
}

resource "yandex_vpc_security_group" "vpc_dev" {
  name       = "vpc_${var.env_name}-sg"
  network_id = yandex_vpc_network.vpc_dev.id
  folder_id  = var.folder_id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

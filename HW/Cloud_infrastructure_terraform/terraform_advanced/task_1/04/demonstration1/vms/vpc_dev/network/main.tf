data "yandex_client_config" "client" {}

resource "yandex_vpc_network" "vpc_dev" {
  name      = "vpc-dev"
  folder_id = data.yandex_client_config.client.folder_id
}

resource "yandex_vpc_subnet" "vpc_dev" {
  for_each       = var.subnets
  name           = "vpc_dev-${each.key}"
  folder_id      = data.yandex_client_config.client.folder_id
  network_id     = yandex_vpc_network.vpc_dev.id
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.v4_cidr_blocks]
}

resource "yandex_vpc_security_group" "vpc_dev" {
  name       = "vpc_dev-sg"
  network_id = yandex_vpc_network.vpc_dev.id
  folder_id  = data.yandex_client_config.client.folder_id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

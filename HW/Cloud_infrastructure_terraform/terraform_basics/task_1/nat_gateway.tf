# NAT Gateway for outbound internet access
resource "yandex_vpc_gateway" "nat_gateway" {
  name      = "nat-gateway"
  folder_id = var.folder_id

  shared_egress_gateway {}
}

# Route table for routing traffic through NAT gateway
resource "yandex_vpc_route_table" "rt" {
  name       = "route-table"
  folder_id  = var.folder_id
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

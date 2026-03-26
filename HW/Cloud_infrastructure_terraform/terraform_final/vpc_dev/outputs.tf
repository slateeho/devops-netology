output "network_name" {
  value = yandex_vpc_network.vpc_dev.name
}

output "network_id" {
  value = yandex_vpc_network.vpc_dev.id
}

output "subnet_zone" {
  value = { for i, v in yandex_vpc_subnet.vpc_dev : i => v.zone }
}

output "subnet_v4_cidr_blocks" {
  value = { for i, v in yandex_vpc_subnet.vpc_dev : i => v.v4_cidr_blocks }
}

output "subnet_ids" {
  value = { for k, v in yandex_vpc_subnet.vpc_dev : k => v.id }
}

output "security_group_id" {
  value = yandex_vpc_security_group.vpc_dev.id
}

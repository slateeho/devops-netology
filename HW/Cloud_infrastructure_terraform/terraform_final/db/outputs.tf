output "db_vm_ids" {
  value = yandex_compute_instance.db_vm[*].id
}

output "db_vm_internal_ips" {
  value = yandex_compute_instance.db_vm[*].network_interface[0].ip_address
}

output "db_vm_public_ips" {
  value = yandex_compute_instance.db_vm[*].network_interface[0].nat_ip_address
}

output "db_vm_names" {
  value = yandex_compute_instance.db_vm[*].name
}

output "db_primary_ip" {
  value = yandex_compute_instance.db_vm[0].network_interface[0].ip_address
}

output "db_primary_public_ip" {
  value = yandex_compute_instance.db_vm[0].network_interface[0].nat_ip_address
}

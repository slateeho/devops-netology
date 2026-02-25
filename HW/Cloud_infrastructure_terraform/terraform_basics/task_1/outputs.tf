###vm_db outputs
output "vm_db_instance_name" {
  value       = yandex_compute_instance.netology-develop-platform-db.name
  description = "DB VM instance name"
}

output "vm_db_external_ip" {
  value       = yandex_compute_instance.netology-develop-platform-db.network_interface[0].nat_ip_address
  description = "DB VM external IP address"
}

output "vm_db_fqdn" {
  value       = yandex_compute_instance.netology-develop-platform-db.fqdn
  description = "DB VM FQDN"
}

###vm_web outputs
output "vm_web_instance_name" {
  value       = yandex_compute_instance.platform_web.name
  description = "Web VM instance name"
}

output "vm_web_external_ip" {
  value       = yandex_compute_instance.platform_web.network_interface[0].nat_ip_address
  description = "Web VM external IP address"
}

output "vm_web_fqdn" {
  value       = yandex_compute_instance.platform_web.fqdn
  description = "Web VM FQDN"
}

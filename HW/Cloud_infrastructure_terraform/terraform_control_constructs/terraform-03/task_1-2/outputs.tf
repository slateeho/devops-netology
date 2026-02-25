output "db_instance_names" {
  description = "Names of YC compute instances (for_each)."
  value       = [for vm in yandex_compute_instance.db : vm.name]
}

output "db_instances" {
  description = "DB instances"
  value       = yandex_compute_instance.db
}

output "storage_instance_names" {
  description = "Names of YC storage compute instances."
  value       = yandex_compute_instance.storage.name
}

output "storage_instance_fqdn" {
  description = "FQDN of YC storage compute instance."
  value       = yandex_compute_instance.storage.fqdn
}

output "storage_instance_external_ip" {
  description = "External IP of YC storage compute instance."
  value       = yandex_compute_instance.storage.network_interface[0].nat_ip_address
}

output "storage_disk_ids" {
  description = "IDs of YC storage disks."
  value       = [for disk in yandex_compute_disk.storage_disk : disk.id]
}
locals {
  db_instances_flat = flatten([
    for vm_key, vm in yandex_compute_instance.db : [
      {
        name        = vm.name
        fqdn        = vm.fqdn
        external_ip = vm.network_interface[0].nat_ip_address
      }
    ]
  ])

  storage_instance_flat = [
    {
      name        = yandex_compute_instance.storage.name
      fqdn        = yandex_compute_instance.storage.fqdn
      external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    }
  ]
}

output "db_instances" {
  description = "DB instances with flattened structure"
  value       = local.db_instances_flat
}

output "storage_instance" {
  description = "Storage instance details"
  value       = local.storage_instance_flat
}

output "storage_disk_ids" {
  description = "IDs of YC storage disks."
  value       = [for disk in yandex_compute_disk.storage_disk : disk.id]
}
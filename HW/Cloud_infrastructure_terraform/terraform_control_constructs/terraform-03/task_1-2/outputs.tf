locals {
  all_instances = concat(
    flatten([
      for vm_key, vm in yandex_compute_instance.db : [
        {
          name        = vm.name
          fqdn        = vm.fqdn
          external_ip = vm.network_interface[0].nat_ip_address
        }
      ]
    ]),
    [
      {
        name        = yandex_compute_instance.storage.name
        fqdn        = yandex_compute_instance.storage.fqdn
        external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      }
    ]
  )
}

output "instances" {
  description = "Single list of dicts"
  value       = local.all_instances
}

output "storage_disk_ids" {
  description = "IDs of YC storage disks."
  value       = [for disk in yandex_compute_disk.storage_disk : disk.id]
}
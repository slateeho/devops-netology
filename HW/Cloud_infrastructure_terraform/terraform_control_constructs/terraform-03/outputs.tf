locals {
  web_instances_flat = flatten([
    for vm in yandex_compute_instance.web : [
      {
        name        = vm.name
        fqdn        = vm.fqdn
        external_ip = vm.network_interface[0].nat_ip_address
      }
    ]
  ])
}

output "web_instances" {
  description = "Web instances with flattened structure"
  value       = local.web_instances_flat
}

output "db_instances_from_child" {
  value = module.child.instances
}

output "storage_disk_ids_from_child" {
  value = module.child.storage_disk_ids
}

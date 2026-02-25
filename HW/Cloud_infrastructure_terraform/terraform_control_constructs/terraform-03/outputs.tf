output "web_instance_names" {
  value = yandex_compute_instance.web[*].name
}

output "db_instances_from_child" {
  value = module.child.db_instances
}

output "storage_instance_from_child" {
  value = {
    name = module.child.storage_instance_names
    nat_ip = module.child.storage_instance_external_ip
    fqdn = module.child.storage_instance_fqdn
  }
}

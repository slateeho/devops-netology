
resource "local_file" "hosts_yaml" {
  depends_on = [yandex_compute_instance.web, module.child]
  content = <<-INI
all:
  children:
    webservers:
      hosts:
%{for i, name in yandex_compute_instance.web[*].name ~}
        ${name}:
          ansible_host: ${yandex_compute_instance.web[i].network_interface[0].nat_ip_address}
          fqdn: ${yandex_compute_instance.web[i].fqdn}
          ansible_user: ${local.ansible_user}
          ansible_ssh_private_key_file: ${local.web_private_key}
%{endfor ~}
    databases:
      hosts:
%{for db_instance in module.child.db_instances ~}
        ${db_instance.name}:
          ansible_host: ${db_instance.external_ip}
          fqdn: ${db_instance.fqdn}
          ansible_user: ${local.ansible_user}
          ansible_ssh_private_key_file: ${local.db_private_key}
%{endfor ~}
    storage:
      hosts:
        ${module.child.storage_instance[0].name}:
          ansible_host: ${module.child.storage_instance[0].external_ip}
          fqdn: ${module.child.storage_instance[0].fqdn}
          ansible_user: ${local.ansible_user}
          ansible_ssh_private_key_file: ${local.db_private_key}
INI
  filename = "${path.module}/ansible/hosts.yaml"
}

resource "null_resource" "ansible_ping" {
  depends_on = [yandex_compute_instance.web]
  
  provisioner "local-exec" {
    command = "sleep 53 && ANSIBLE_HOST_KEY_CHECKING=False ansible all -i ${path.module}/ansible/hosts.yaml -m ping"
  }
  
  triggers = {
    inventory_content = local_file.hosts_yaml.content
  }
}

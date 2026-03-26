output "web_vm_internal_ip" {
  value = yandex_compute_instance.web.network_interface[0].ip_address
}

output "web_vm_public_ip" {
  value = yandex_compute_instance.web.network_interface[0].nat_ip_address
}
output "cert_paths" {
  value = {
    key = "/etc/ssl/private/app.key"
    crt = "/etc/ssl/certs/app.crt"
  }
}


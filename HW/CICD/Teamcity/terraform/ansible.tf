resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    hosts       = { for name, vm in yandex_compute_instance.debian : name => vm.network_interface[0].nat_ip_address }
    private_key = local.private_key
  })

  filename = "${path.module}/infrastructure/inventory.yml"
}

resource "null_resource" "cloud_init_wait" {
  depends_on = [
    yandex_compute_instance.debian,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = "sleep 20"
  }
}

resource "null_resource" "ansible_ping" {
  depends_on = [
    null_resource.cloud_init_wait,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = "ansible all -i ${local_file.ansible_inventory.filename} -m ping"
  }
}

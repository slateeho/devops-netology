resource "local_file" "hosts_ini" {
  depends_on = [null_resource.cloud_init_wait]
  
  content = templatefile("${path.module}/hosts.tftpl", {
    web_vm_ip       = yandex_compute_instance.web.network_interface[0].nat_ip_address
    db_host         = module.db.db_primary_ip
    username        = var.vm_user
    private_key     = local.private_key
    path_module     = path.module
  })
  filename = "${path.module}/hosts.ini"
}


resource "null_resource" "ansible_ping" {
  depends_on = [local_file.hosts_ini]

  provisioner "local-exec" {
    command = "ansible all -i ${local_file.hosts_ini.filename} -m ping || true"
  }
}
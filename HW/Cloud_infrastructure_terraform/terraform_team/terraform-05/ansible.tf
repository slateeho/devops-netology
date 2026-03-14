resource "local_file" "hosts_ini" {
  depends_on = [module.marketing_vm, module.analytics_vm]
  content = templatefile("${path.module}/hosts.tftpl", {
    marketing_vm_instances  = local.marketing_vm_flat
    analytics_vm_instances  = local.analytics_vm_flat
    username                = local.username
    private_key             = local.private_key
  })
  filename = "${path.module}/ansible/hosts.ini" 
}

resource "null_resource" "cloud_init_wait" {
  depends_on = [module.marketing_vm, module.analytics_vm]
}

resource "null_resource" "nginx_test" {
  depends_on = [local_file.hosts_ini, null_resource.cloud_init_wait]

  provisioner "local-exec" {
    command = "ansible all -i ${local_file.hosts_ini.filename} -b -a 'nginx -t' || true"
  }
}

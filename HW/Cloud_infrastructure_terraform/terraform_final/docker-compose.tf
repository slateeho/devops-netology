resource "null_resource" "cloud_init_wait" {
  depends_on = [yandex_compute_instance.web, module.db]

  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait", 
    ]

    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = local.private_key
      host        = yandex_compute_instance.web.network_interface[0].nat_ip_address
      timeout     = "15m"
      agent       = false
    }
  }
}

resource "local_file" "docker_compose_file" {
  depends_on = [yandex_compute_instance.web, module.db]

  content = templatefile("${path.module}/docker-compose.tftpl", {
    db_host     = module.db.db_primary_ip
    db_name     = var.database_name
    db_user     = var.user_name
    db_password = random_password.db_password.result
  })

  filename = "${path.module}/docker-compose.yml"
}

resource "null_resource" "upload_and_run_docker_compose" {
  depends_on = [null_resource.cloud_init_wait]

  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p /tmp/awesome-compose/react-java-mysql"]

    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = local.private_key
      host        = yandex_compute_instance.web.network_interface[0].nat_ip_address
      timeout     = "5m"
      agent       = false
    }
  }

  provisioner "file" {
    source      = "${path.module}/awesome-compose/react-java-mysql"
    destination = "/tmp/awesome-compose/react-java-mysql"

    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = local.private_key
      host        = yandex_compute_instance.web.network_interface[0].nat_ip_address
      timeout     = "5m"
      agent       = false
    }
  }

  provisioner "file" {
    source      = local_file.docker_compose_file.filename
    destination = "/tmp/awesome-compose/react-java-mysql/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = local.private_key
      host        = yandex_compute_instance.web.network_interface[0].nat_ip_address
      timeout     = "5m"
      agent       = false
    }
  }

provisioner "remote-exec" {
  inline = [
    "sleep 10",
    "for i in {1..30}; do docker ps >/dev/null 2>&1 && break || sleep 1; done",
    "echo '${var.yc_token}' | docker login --username oauth --password-stdin cr.yandex",
    "cd /tmp/awesome-compose/react-java-mysql && docker compose up -d"
  ]

  connection {
    type        = "ssh"
    user        = var.vm_user
    private_key = local.private_key
    host        = yandex_compute_instance.web.network_interface[0].nat_ip_address
    timeout     = "5m"
    agent       = false
  }
}

}
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

data "terraform_remote_state" "server" {
  backend = "local"
  config = {
    path = "../task_2_asterisk/terraform.tfstate"
  }
}

provider "docker" {
  host     = data.terraform_remote_state.server.outputs.docker_host
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

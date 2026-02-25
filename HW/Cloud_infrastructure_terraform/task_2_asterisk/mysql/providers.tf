terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

data "terraform_remote_state" "server" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "docker" {
  host     = "ssh://debian@${data.terraform_remote_state.server.outputs.vm_external_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "/home/a/.ato4ka/security/.ssh/yandex/yandex.pem"]
}

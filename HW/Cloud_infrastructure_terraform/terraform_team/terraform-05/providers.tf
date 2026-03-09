terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
  required_version = "~>1.12.0"

  backend "s3" {
    bucket  = "lao-ush244oz"
    key     = "terraform.tfstate"
    region  = "ru-central1"

    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ssm_parameter" "iam_token" {
  name            = "/yandex/yc-iam-token"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/terraform/db-password"
  with_decryption = true
}

data "aws_ssm_parameter" "s3_secret" {
  name            = "/terraform/s3-secret"
  with_decryption = true
}

data "aws_ssm_parameter" "sa_key" {
  name            = "/terraform/sa-key"
  with_decryption = true
}

provider "yandex" {
  token    = data.aws_ssm_parameter.iam_token.value
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  zone     = var.default_zone
}

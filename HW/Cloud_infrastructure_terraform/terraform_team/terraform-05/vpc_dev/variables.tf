variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type = string
}

variable "env_name" {
  type    = string
  default = "develop"
}

variable "subnets" {
  type = map(object({
    zone           = string
    v4_cidr_blocks = string
  }))
  default = {
    "vpc_dev_a" = {
      zone           = "ru-central1-a"
      v4_cidr_blocks = "10.0.1.0/24"
    }
    "vpc_dev_b" = {
      zone           = "ru-central1-b"
      v4_cidr_blocks = "10.0.3.0/24"
    }
  }
}

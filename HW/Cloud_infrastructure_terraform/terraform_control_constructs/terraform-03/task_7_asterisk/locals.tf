# Original data assignment
locals {
  vpc = {
    network_id = "enp7i560tb28nageq0cc"
    subnet_ids = [
      "e9b0le401619ngf4h68n",
      "e2lbar6u8b2ftd7f5hia",
      "b0ca48coorjjq93u36pl",
      "fl8ner8rjsio6rcpcf0h",
    ]
    subnet_zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-c",
      "ru-central1-d",
    ]
  }
}

# Filtered data (remove 3rd element, index 2)
locals {
  vpc_filtered = {
    network_id   = local.vpc.network_id
    subnet_ids   = [for i, v in local.vpc.subnet_ids : v if i != 2]
    subnet_zones = [for i, v in local.vpc.subnet_zones : v if i != 2]
  }
}

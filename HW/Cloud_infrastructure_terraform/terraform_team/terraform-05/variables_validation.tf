variable "ip_address" {
  type        = string
  description = "ip-адрес"
  default     = "192.168.0.1"
  
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", var.ip_address))
    error_message = "Значение должно быть корректным IP-адресом."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "список ip-адресов"
  default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  
  validation {
    condition = alltrue([
      for ip in var.ip_addresses : can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", ip))
    ])
    error_message = "Все значения должны быть корректными IP-адресами."
  }
}

variable "lowercase_string" {
  type        = string
  description = "любая строка"
  default     = "hello world"
  
  validation {
    condition     = var.lowercase_string == lower(var.lowercase_string)
    error_message = "Строка не должна содержать символов верхнего регистра."
  }
}

variable "in_the_end_there_can_be_only_one" {
  description = "Who is better Connor or Duncan?"
  type = object({
    Dunkan = optional(bool)
    Connor = optional(bool)
  })

  default = {
    Dunkan = true
    Connor = false
  }

  validation {
    error_message = "There can be only one MacLeod"
    condition     = (var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor)
  }
}

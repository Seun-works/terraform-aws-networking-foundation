# Purpose: Define the input variables for the networking module
variable "vpc_cidr" {
  type = object({
    name = string
    cidr = string
  })

  validation {
    condition = can(cidrnetmask(var.vpc_cidr.cidr))
    error_message = "Invalid CIDR block"
  }
}

variable "subnet_config" {
  type = map(object({
    cidr = list(string)
    azs = list(string)
    public = optional(bool, false)
  }))

  validation {
    condition = alltrue([for key, value in var.subnet_config: alltrue([for cidr in value.cidr : can(cidrnetmask(cidr))]) ])
    error_message = "Invalid CIDR block used for subnet"
  }
}
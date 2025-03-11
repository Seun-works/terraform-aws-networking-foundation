# Purpose: Define the input variables for the networking module
variable "vpc_cidr" {
  description = "This is the CIDR block and name for the VPC"
  type = object({
    name = string
    cidr = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr.cidr))
    error_message = "Invalid CIDR block"
  }
}

variable "subnet_config" {
  description = <<EOT
  This accepts a map of subnet configurations. Each subnet configuration should contain

  - cidr: The CIDR block for the subnet
  - az: The availability zone for the subnet
  - public: A boolean value to determine if the subnet is public or private
  - tags: A map of tags to apply to the subnet
  EOT
  type = map(object({
    cidr   = string
    az    = string
    public = optional(bool, false)
    tags   = optional(map(string))
  }))

  validation {
    condition     = alltrue([for key, value in var.subnet_config : can(cidrnetmask(value.cidr))])
    error_message = "Invalid CIDR block used for subnet"
  }
}

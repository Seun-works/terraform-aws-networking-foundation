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

  - cidr: A list of CIDR blocks for the subnet
  - azs: A list of availability zones for the subnet
  - public: A boolean value to determine if the subnet is public or private
  EOT
  type = map(object({
    cidr = list(string)
    azs  = list(string)
  public = optional(bool, false) }))

  validation {
    condition     = alltrue([for key, value in var.subnet_config : alltrue([for cidr in value.cidr : can(cidrnetmask(cidr))])])
    error_message = "Invalid CIDR block used for subnet"
  }
}

module "vpc" {
  source = "./modules/networking"
  vpc_cidr = {
    name = "Module VPC"
    cidr = "10.0.0.0/16"
  }
  subnet_config = {
    subnet_1 = {
      cidr = "10.0.0.0/24"
      azs  = "us-east-1a"
      # Public subnets are identified by the public attribute
      public = true
      tags = {
        Name = "Public Subnet"
      }
    },

    subnet_2 = {
      cidr = "10.0.1.0/24"
      azs  = "us-east-1a"
      # Private subnets are identified by the public attribute not being defined as it defaults to false
      tags = {
        Name = "Private Subnet"
      }
    },

  }
}
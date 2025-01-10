# Networking Module
This module manages the creation of VPCs and Subnets, allowing for the creation of both private and public subnets

Example usage:
```
module "vpc" {
  source = "./modules/networking"
  vpc_cidr = {
    name = "your_vpc"
    cidr = "10.0.0.0/16"
  }
  subnet_config = {
    subnet_1 = {
      cidr   = ["10.0.0.0/24"]
      azs    = ["us-east-1a"]
      public = true
    }
  }
}

```
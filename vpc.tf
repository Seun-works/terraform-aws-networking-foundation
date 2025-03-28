locals {
  public_subnets  = { for key, value in var.subnet_config : key => value if value.public == true }
  private_subnets = { for key, value in var.subnet_config : key => value if value.public == false }

  outputs_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      id   = aws_subnet.main_subnet[key].id
      tags = var.subnet_config[key].tags
    }
  }

  outputs_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      id   = aws_subnet.main_subnet[key].id
      tags = var.subnet_config[key].tags
    }
  }

}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr.cidr
  tags = {
    Name = "Module VPC"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.subnet_config
  cidr_block        = var.subnet_config[each.key].cidr
  availability_zone = var.subnet_config[each.key].az
  map_public_ip_on_launch = var.subnet_config[each.key].public


  tags = var.subnet_config[each.key].tags

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available_zones.names, var.subnet_config[each.key].az)
      error_message = "Availability zone ${var.subnet_config[each.key].az} is not available in the region"
    }
  }
}

resource "aws_internet_gateway" "main_igw" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Module VPC IGW"
  }
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnets) > 0 ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw[0].id
  }
}

resource "aws_route_table_association" "rt_association" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.main_subnet[each.key].id
  route_table_id = aws_route_table.main_rt[0].id
}
output "vpc_id" {
  description = "The Id of the VPC"
  value = aws_vpc.main.id
}

output "public_subnets" {
    description = "The Id's and availability zones of the public subnets"
    value = local.outputs_public_subnets
}

output "private_subnets" {
    description = "The Id's and availability zones of the private subnets"
    value = local.outputs_private_subnets
}
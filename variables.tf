variable "aws_region" {
    description = "my default AWS Region"
    type = string
}

variable "vpc_cidr_block" {
    description = "cidr block for VPC"
    type = string
}

variable "enable_dns_hostnames" {
    description = "enable DNS hostnames for your VPC"
    type = bool
}

variable "resource_tags" {
    description = "value"
    type = map(string)
  
}

variable "public_subnets_cidrs" {
    description = "cidr for the public subnet"
    type = list(string)
}

variable "private_application_subnets_cidrs" {
    description = "cidr for the private application subnet"
    type = list(string)
}

variable "private_data_subnets_cidrs" {
    description = "cidr for the privatem data subnet"
    type = list(string)
}

variable "map_public_ip_on_launch" {
    description = "Map_public_ip_on_launch"
    type = bool
}

variable "route_table_cidr" {
    description = "my_route_table_cidrs"
    type = string
}


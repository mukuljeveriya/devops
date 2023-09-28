variable "region" {
  type = string
  default = "ap-south-1"
}

variable "name" {
  default = "dev"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "private_subnet_cidr_block_1a" {
  default = "10.10.0.0/19"
}

variable "private_subnet_cidr_block_1b" {
  default = "10.10.32.0/19"
}

variable "private_subnet_cidr_block_1c" {
  default = "10.10.64.0/19"
}

variable "public_subnet_cidr_block_1a" {
  default = "10.10.96.0/19"
}

variable "public_subnet_cidr_block_1b" {
  default = "10.10.128.0/19"
}

variable "public_subnet_cidr_block_1c" {
  default = "10.10.160.0/19"
}

variable "node_group_count" {
  default = "3"
}

variable "instancetype" {
  default = {
    0 = ["t2.small", "t2.micro"]
    1 = ["t3.small", "t3.micro"]
    2 = ["t2.small", "t2.micro"]
  }
}

variable "scalemin" {
  default = "1"
}

variable "scalemax" {
  default = "5"
}

variable "scaledesired" {
  default = "1"
}
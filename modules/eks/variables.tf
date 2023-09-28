variable "node_type" {
  type = map(any)
  default = {
    0 = "ON_DEMAND"
    1 = "ON_DEMAND"
    2 = "ON_DEMAND"
  }
}

variable "disk_size" {
  type = map(any)
  default = {
    0 = "50"
    1 = "50"
    2 = "50"
  }
}

variable "labels" {
  type = map(any)
  default = {
    0 = "chat-api"
    1 = "liu-v2"
    2 = "ivory"
  }
}

variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "node_group_count" {
  type = string
}

variable "k8s_subnets" {
  type = list(any)
}

variable "instancetype" {
  type = map(any)
}

variable "scalemin" {
  type = number
}

variable "scalemax" {
  type = number
}

variable "scaledesired" {
  type = number
}

variable "vpc_cidr_block" {
  type = string
}

variable "role_arn" {}

variable "k8s_vpc_id" {} 
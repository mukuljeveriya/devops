resource "aws_vpc" "vpc_k8s" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name    = "${var.name}-vpc-k8s"
    project = "${var.name}"
    env    = "${var.env}"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.private_subnet_cidr_block_1a
  availability_zone       = "ap-south-1a"

  tags = {
    Name                                            = "${var.name}-private-subnet-1a"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"               = 1

  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.private_subnet_cidr_block_1b
  availability_zone       = "ap-south-1b"

  tags = {
    Name                                            = "${var.name}-private-subnet-1b"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"               = 1

  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.private_subnet_cidr_block_1c
  availability_zone       = "ap-south-1c"

  tags = {
    Name                                            = "${var.name}-private-subnet-1c"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"               = 1

  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.public_subnet_cidr_block_1a
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.name}-public-subnet-1a"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                        = 1

  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.public_subnet_cidr_block_1b
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.name}-public-subnet-1b"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                        = 1

  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.public_subnet_cidr_block_1c
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.name}-public-subnet-1c"
    env                                             = var.name
    project                                         = "${var.name}"
    "kubernetes.io/cluster/${var.name}-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                        = 1

  }
}


resource "aws_internet_gateway" "igw_k8s" {
  vpc_id = aws_vpc.vpc_k8s.id

  tags = {
    Name          = "${var.name}-k8s-igw"
    env           = "${var.env}"
    project       = "${var.name}"

  }
}

resource "aws_eip" "ngw_k8s" {
    #vpc    = true
    domain = "vpc"
    tags   = {
    Name          = "${var.name}-k8s-ngw"
    env           = "${var.env}"
    project       = "${var.name}"
  }
}

resource "aws_nat_gateway" "ngw_k8s" {
    allocation_id = aws_eip.ngw_k8s.id
    subnet_id     = aws_subnet.public_subnet_1a.id
    
    tags = {
    Name          = "${var.name}-k8s-ngw"
    env           = "${var.env}"
    project       = "${var.name}"
  }

  depends_on = [aws_internet_gateway.igw_k8s]  
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_k8s.id
  }

  tags = {
    Name          = "${var.name}-private-routerable"
    env           = "${var.env}"
    project       = "${var.name}"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_k8s.id
  }

  tags = {
    Name          = "${var.name}-public-routerable"
    env           = "${var.env}"
    project       = "${var.name}"
  }
}

resource "aws_route_table_association" "rta_private_subnet_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "rta_private_subnet_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "rta_private_subnet_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "rta_public_subnet_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "rta_public_subnet_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "rta_public_subnet_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.route_table_public.id
}
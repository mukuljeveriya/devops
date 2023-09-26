module "vpc" {
  source                       = "../modules/vpc"
  name                         = var.name
  env                          = var.env
  vpc_cidr_block               = var.vpc_cidr_block
  private_subnet_cidr_block_1a = var.private_subnet_cidr_block_1a
  private_subnet_cidr_block_1b = var.private_subnet_cidr_block_1b
  private_subnet_cidr_block_1c = var.private_subnet_cidr_block_1c
  public_subnet_cidr_block_1a  = var.public_subnet_cidr_block_1a
  public_subnet_cidr_block_1b  = var.public_subnet_cidr_block_1b
  public_subnet_cidr_block_1c  = var.public_subnet_cidr_block_1c
}
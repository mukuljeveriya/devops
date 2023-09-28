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

module "iam" {
  source = "../modules/iam"
  name    = var.name
}

module "eks" {
  source            = "../modules/eks"
  name              = var.name
  env               = var.env
  role_arn          = module.iam.iam_role_arn
  k8s_subnets       = module.vpc.k8s_subnet_ids
  k8s_vpc_id        = module.vpc.k8s_vpc_id
  vpc_cidr_block    = var.vpc_cidr_block
  region            = var.region
  instancetype      = var.instancetype
  scalemin          = var.scalemin
  scalemax          = var.scalemax
  scaledesired      = var.scaledesired
  node_group_count  = var.node_group_count
  depends_on        = [module.iam]
}

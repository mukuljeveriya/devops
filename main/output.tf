output "cluster_name" {
  value = module.eks.cluster_id
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = module.vpc.k8s_vpc_id
}
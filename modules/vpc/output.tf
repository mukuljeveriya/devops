output "k8s_vpc_id" {
  value = aws_vpc.vpc_k8s.id
}

output "k8s_vpc_id_cidr" {
  value = aws_vpc.vpc_k8s.cidr_block
}

output "k8s_subnet_ids" {
  value = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id, aws_subnet.private_subnet_1c.id, aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id, aws_subnet.public_subnet_1c.id]
}
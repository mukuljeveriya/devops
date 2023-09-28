resource "aws_security_group" "security_group_eks" {
  name        = "${var.name}-eks-allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = var.k8s_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-sg"
    env         = var.env
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.name}-eks-cluster"
  role_arn = var.role_arn

  vpc_config {
    subnet_ids         = var.k8s_subnets
    security_group_ids = [aws_security_group.security_group_eks.id]
  }

  depends_on = [aws_security_group.security_group_eks]
}

resource "aws_eks_node_group" "eks_cluster_node_group" {
  count           = var.node_group_count
  cluster_name    = aws_eks_cluster.eks_cluster.id
  node_group_name = "${lookup(var.labels, count.index)}-${lookup(var.node_type, count.index)}-eks-node"
  #node_group_name = "${element(var.labels, count.index)}-${lookup(var.node_type, count.index)}-eks-node"
  #node_group_name = "${lookup(var.labels, count.index) == "chat-api" ? "chat-api" : lookup(var.labels, count.index)}-${lookup(var.node_type, count.index) == "liu_v2" ? "liu_v2" : "testing"}"
  node_role_arn   = var.role_arn
  subnet_ids      = var.k8s_subnets
  disk_size       = lookup(var.disk_size, count.index)
  instance_types  = lookup(var.instancetype, count.index)
  capacity_type   = lookup(var.node_type, count.index)

  scaling_config {
    desired_size = var.scaledesired
    max_size     = var.scalemax
    min_size     = var.scalemin
  }

  depends_on = [aws_eks_cluster.eks_cluster]

  labels = {
    #nodegroup         = element(var.labels, count.index)
    nodegroup         = lookup(var.labels, count.index)
    type_of_nodegroup = lookup(var.node_type, count.index) == "SPOT" ? "spot_untainted" : "on_demand"
  }

  tags = {
    Name              = "${lookup(var.labels, count.index)}-${lookup(var.node_type, count.index)}-eks-node"
    env               = var.env
  }

  lifecycle {
    ignore_changes = [scaling_config]
  }
}

data "tls_certificate" "tls" {
  url        = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_iam_openid_connect_provider" "open_id" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  depends_on      = [data.tls_certificate.tls, aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"

  depends_on = [
   # aws_eks_node_group.eks_cluster_node_group
  ]
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "csi_driver" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.eks_cluster_node_group
  ]
}
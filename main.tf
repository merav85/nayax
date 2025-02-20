variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "eks_cluster_name" {
  default = "my-eks-cluster"
}

variable "environments" {
  type    = list(string)
  default = ["dev", "stage", "prod"]
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "eks_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet.id]
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = [aws_subnet.eks_subnet.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

resource "aws_iam_role" "node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.environments)
  metadata {
    name = each.key
  }
}

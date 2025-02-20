provider "aws" {
  region = "eu-west-1"
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
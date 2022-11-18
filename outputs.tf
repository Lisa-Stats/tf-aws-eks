output "vpc-id" {
  value = module.vpc.vpc_id
}

output "private-subnets" {
  value = module.vpc.private_subnets
}

output "data-eks-cluster" {
  value = data.aws_eks_cluster.default
}

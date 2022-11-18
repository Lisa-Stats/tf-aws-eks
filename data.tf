data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

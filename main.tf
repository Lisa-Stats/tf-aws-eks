provider "aws" {
  region = "us-west-1"
}

provider "kubernetes" {
  host = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
      command     = "aws"
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "my-eks"
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      description = "allow access from control plane to webhook of aws lb-controller"
      type = "ingress"
      protocol = "tcp"
      from_port = 9443
      to_port = 9443
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    dev = {
      name = "dev-nodes"

      instance_types = ["t3.micro"]
      capacity_type = "SPOT"
      min_size = 1
      max_size = 3
      desired_size = 2

      labels = {
        role = "dev"
      }
    }
    test = {
      name = "test-nodes"

      instance_types = ["t3.micro"]
      capacity_type = "SPOT"
      min_size = 1
      max_size = 3
      desired_size = 2

      labels = {
        role = "test"
      }
    }
  }

  tags = {
    "terraform" = "true"
  }
}

Deployment for AWS EKS cluster using Terraform

Uses Terraform modules to create:
- VPC
- Private subnets
- Public subnets
- NAT gateway
- Internet gateway
- IRSA role for AWS load balancer controller
- EKS cluster
  - 2 managed node groups

Uses Helm to create:
- AWS load balancer controller

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "i3i-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name = "i3i-vpc"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.28.0"

  cluster_name    = "i3i-cluster"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      ami_type        = "AL2023_x86_64_STANDARD"
      instance_types  = ["t3.medium"]
      desired_size    = 1
      max_size        = 1
      min_size        = 1

      tags = {
        Name       = "eks-i3i-node"
        Owner      = "alex-i3i"
        AutoDelete = "true"
        Purpose    = "multi-tenant-fiware"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "i3i"
  }
}


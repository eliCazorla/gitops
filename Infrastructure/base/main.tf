// siempre que se agrega un modulo hay que hacer un init para que los descargue.
module "eks_taller_devops" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "~> 18.21"
  
  cluster_name                    = "cluster_taller_devops"
  cluster_version                 = "1.26"

  create_iam_role                 = false
  iam_role_arn                    = var.role_arn
  iam_role_name                   = "LabRole"

  cluster_endpoint_public_access  = true

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnets 
  control_plane_subnet_ids        = var.subnets // no necesariamente tienen que ser las mismas que la de arriba.

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = [ "t3.micro" ]
  }

  # 2 node groups distintos con estrategia blue/green de deploy.
  eks_managed_node_groups = {
    workers = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types           = ["t3.small"]
      capacity_type            = "ON_DEMAND"
      iam_role_arn             = var.role_arn
      iam_instance_profile_arn = var.role_arn
      create_iam_role          = false
      create_role              = false
    }
  }

  # aws-auth configmap
  # manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = var.role_arn
  #     username = "LabRole"
  #     groups   = ["system:masters"] // administrador del cluster.
  #   },
  # ]

  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user2"
  #     username = "user2"
  #     groups   = ["system:masters"]
  #   },
  # ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
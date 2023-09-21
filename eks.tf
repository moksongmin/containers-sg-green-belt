module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }

    coredns = {
      preserve    = true
      most_recent = true
    }

    # timeouts = {
    #   create = "25m"
    #   delete = "10m"
    # }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }
  }

  cluster_tags = {
    Name = local.cluster_name
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  manage_aws_auth_configmap = true
  create_aws_auth_configmap = false #Set to 'true' when creating the cluster for a first time.

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  eks_managed_node_groups = {
    managed = {
      name            = "${local.cluster_name}-managed-node"
      use_name_prefix = true

      subnet_ids = module.vpc.private_subnets

      min_size     = 1
      max_size     = 3
      desired_size = 1

      force_update_version = true
      instance_types       = ["t3.small"]
      ami_type             = "BOTTLEROCKET_x86_64"


      description = "EKS managed node group launch template"

      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = false

      create_iam_role          = true
      iam_role_name            = "${local.cluster_name}-node-group-role"
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group role"
      iam_role_tags = {
        Purpose = "Protector of the kubelet"
      }

      iam_role_attach_cni_policy = true

      iam_role_additional_policies = {
        EBS_CSI = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      create_security_group          = true
      security_group_name            = "${local.cluster_name}-node-group-sg"
      security_group_use_name_prefix = false

      tags = {
        ExtraTag                                     = "EKS managed node group"
        "k8s.io/cluster-autoscaler/enabled"          = 1
        "k8s.io/cluster-autoscaler/APP-DEV-EKS-RCON" = 1
      }
    }
  }

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${local.account_id}:role/SandboxAdmin"
      username = "momchi"
      groups   = ["system:masters"]
    }
  ]

  tags = local.tags
}
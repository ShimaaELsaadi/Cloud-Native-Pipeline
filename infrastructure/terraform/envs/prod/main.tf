module "network" {
  source      = "../../modules/network"
  environment = var.environment
  vpc_config = {
    cidr_block = "10.0.0.0/16"
  }
  subnet_config = {
    subnet1 = {
      cidr_block = "10.0.3.0/24"
      public     = true
    }
    subnet2 = {
      cidr_block = "10.0.2.0/24"
      public     = true
    }
  }
}
module "compute" {
  source      = "../../modules/compute"
  environment = var.environment
  vpc_id      = module.network.vpc_id
  instances = {
    k3s-controlplane = {
      instance_type = "t2.small"
      subnet_id     = module.network.subnet_ids["subnet1"]
      key_pair_name = "instance-key-pair"
      Role          = "controlplane"
    }
    k3s-worker = {
      instance_type = "t2.micro"
      subnet_id     = module.network.subnet_ids["subnet2"]  
      key_pair_name = "instance-key-pair"
      Role          = "worker"

    }
  }
  sg_config = {
  description = "allow ssh, http, and K3s required ports"

  ingress = {
    ssh = {
      port  = 22
      cidrs = ["0.0.0.0/0"]
    }

    http = {
      port  = 80
      cidrs = ["0.0.0.0/0"]
    }

    k3s_api = {
      port  = 6443
      cidrs = ["0.0.0.0/0"] 
    }

    etcd = {
      port  = 2379
      cidrs     = ["10.0.0.0/16"] 
    }

    flannel_vxlan = {
      port  = 8472
      protocol = "udp"
      cidrs = ["10.0.0.0/16"]
    }

    kubelet_metrics = {
      port  = 10250
      cidrs = ["10.0.0.0/16"]
    }

    wireguard_ipv4 = {
      port     = 51820
      protocol = "udp"
      cidrs    = ["10.0.0.0/16"]
    }

    wireguard_ipv6 = {
      port     = 51821
      protocol = "udp"
      cidrs    = ["10.0.0.0/16"]
    }

    spegel_registry_1 = {
      port  = 5001
      cidrs = ["10.0.0.0/16"]
    }

    spegel_registry_2 = {
      port  = 6443
      cidrs = ["10.0.0.0/16"]
    }
  }

  egress = {
    all = {
      from_port = 0
      to_port   = 0
      cidrs     = ["0.0.0.0/0"]
    }
  }
  }
}

module "ecr" {
  source = "../../modules/ECR"

  ecr_repository_name       = var.ecr_repository_name
  force_delete              = true
  image_tag_mutability      = "IMMUTABLE"
  encryption_type           = "AES256"
  tags                      = var.tags
  enable_registry_scanning  = true
  enable_secret_scanning    = true
  image_scanning_configuration = [
    {
      scan_on_push = true
    }
  ]
  scan_repository_filters = [
    {
      filter_type  = "WILDCARD"
      filter_value = "*"
    }
  ]
  timeouts = [
    {
      delete = "60m"
    }
  ]
}


module "logging" {
  source             = "../../modules/logging"
  environment        = var.environment
  log_retention_days = 7
  vpc_id             = module.network.vpc_id
}

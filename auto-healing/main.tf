# Network

module "network" {
  source = "./modules/network"

  name                    = local.name_prefix
  vpc_cidr                = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
}

# Load Balancer

module "load_balancer" {
  source = "./modules/load-balancer"

  name              = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}


# Compute

module "compute" {
  source = "./modules/compute"

  name                  = local.name_prefix
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  target_group_arn      = module.load_balancer.target_group_arn
  alb_security_group_id = module.load_balancer.security_group_id
  instance_type         = var.instance_type
}
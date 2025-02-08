provider "aws" {
  region = "us-east-1"
}

module "vpc_ec2" {
  source          = "./modules/vpc_ec2"
  vpc_cidr        = "10.0.0.0/16"
  subnet_count    = 2
  instance_type   = "t2.micro"
  assign_public_ip = true
}

module "alb_autoscaling" {
  source          = "./modules/alb_autoscaling"
  vpc_id          = module.vpc_ec2.vpc_id
  public_subnets  = module.vpc_ec2.public_subnets
  instance_type   = "t2.micro"
  min_instances   = 1
  max_instances   = 3
  assign_public_ip = true
}

output "alb_dns" {
  value = module.alb_autoscaling.alb_dns_name
}

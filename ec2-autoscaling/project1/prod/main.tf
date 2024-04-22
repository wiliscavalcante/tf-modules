module "ec2_autoscaling" {
  source = "../../modules/ec2-autoscaling"

  project_name             = var.project_name
  ami_id                   = var.ami_id
  instance_type            = var.instance_type
  key_name                 = var.key_name
  volume_size              = var.volume_size
  kms_key_id               = var.kms_key_id
  security_group_id        = var.security_group_id
  iam_instance_profile_arn = var.iam_instance_profile_arn
  user_data                = filebase64("user_data.sh")
  min_size                 = var.min_size
  max_size                 = var.max_size
  desired_capacity         = var.desired_capacity
  subnets                  = data.aws_subnets.private.ids
  required_tags            = var.required_tags
  env                      = var.env
  vpc_id = data.aws_vpc.prod_vpc.id
  vpc_cidr = var.vpc_cidr
  aws_account_id = data.aws_caller_identity.current.account_id
  ssl_certificate_arn = var.ssl_certificate_arn
  alb_internal = var.alb_internal
  target_group_port = var.target_group_port
  health_check_path = var.health_check_path
  ssl_policy = var.ssl_certificate_arn
  target_group_protocol =   var.target_group_protocol

}


data "aws_vpc" "prod_vpc" {
  filter {
    name   = "tag:Name"
    values = ["VPC-Prod"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Type"  # ou "tag:Type", dependendo da sua convenção de tags
    values = ["Private"]
  }
}

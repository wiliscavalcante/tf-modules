provider "aws" {
  region = "sa-east-1"  # Substitua pela região desejada
}

module "nlb" {
  source = "./modulo"

  region                       = "sa-east-1"
  name                         = "meu-nlb-teste"
  internal                     = false
  subnet_ids                    = ["subnet-d2aeb4a4", "subnet-23b47078"]  # Substitua pelo ID da sua subnet
  tags                         = { Name = "meu-nlb" }
  enable_cross_zone_load_balancing  = true
}

output "nlb_arn" {
  description = "ARN do Network Load Balancer"
  value       = module.nlb.nlb_arn
}

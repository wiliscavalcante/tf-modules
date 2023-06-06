module "nlb" {
  source  = "./modulo"

  name                            = "my-internal-nlb"
  subnet_ids                      = ["subnet-08d47e590ecc0f621", "subnet-08d47e590ecc0f621"]
  enable_cross_zone_load_balancing = true
  listener_port                   = 443
  listener_protocol               = "TCP"
  target_group_name               = "my-internal-nlb-target-group"
  target_group_port               = 443
  target_group_protocol           = "TCP"
  vpc_id                          = "vpc-b4efa2d3"
  target_id                       = "172.31.28.17"
  target_type                     = "ip"  # Valor personalizado para target_type

  tags = {
    Name = "my-internal-nlb"
    Project = "dev"

  }
}

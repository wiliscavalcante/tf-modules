# Criando o recurso do Network Load Balancer
resource "aws_lb" "network" {
  name               = var.name
  load_balancer_type = "network"
  internal           = var.internal
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  subnet_mapping {
    subnet_id = var.subnet_ids[0]
  }

  subnet_mapping {
    subnet_id = var.subnet_ids[1]
  }

  tags = var.tags
}

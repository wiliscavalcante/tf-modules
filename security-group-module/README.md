# Módulo Terraform: security-group-module

Este módulo Terraform cria um Security Group na AWS. Um Security Group é um conjunto de regras de firewall que controlam o tráfego de entrada e saída para instâncias EC2 dentro da VPC.

## Uso

```hcl
module "security_group" {
  source = "caminho/para/o/modulo/security-group-module"

  security_group_name        = "MeuSecurityGroup"
  security_group_description = "Security Group para permitir tráfego específico"
  vpc_id                     = "vpc-1234567890abcdef0"

  ingress_rules = [
    {
      description  = "Permite tráfego SSH"
      from_port    = 22
      to_port      = 22
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      description  = "Permite tráfego HTTP"
      from_port    = 80
      to_port      = 80
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
  ]

  egress_rules = [
    {
      description  = "Permite todo o tráfego de saída"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    },
  ]
}

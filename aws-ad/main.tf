# Defina suas credenciais da AWS
provider "aws" {
  region     = "sa-east-1" # Substitua pelo valor desejado
}

# Crie um recurso de diretório do AWS Managed Microsoft AD
resource "aws_directory_service_directory" "ad_directory" {
  name                   = "be.local"
  password               = "P@ssw0rd@2023"
  edition                = "Standard"
  type                   = "MicrosoftAD"
  short_name             = "BE"
  vpc_settings {
    vpc_id                = "vpc-b4efa2d3"
    subnet_ids            = ["subnet-08d47e590ecc0f621", "subnet-0bc945ea6d09519bc"]
  }
  tags = {
    Name = "ad-directory"
  }
}

# Output para exibir o DNS do diretório
output "ad_dns" {
  value = tolist(toset(aws_directory_service_directory.ad_directory.dns_ip_addresses))[0]
}

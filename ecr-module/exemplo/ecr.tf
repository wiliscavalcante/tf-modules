provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}


module "ecr_repo" {
  source = "github.com/wiliscavalcante/tf-modules.git//ecr-module-new"

  name        = "meu-repo-privado"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
  enable_lifecycle_policy = true

  tags = {
    Environment = "Production"
    Team = "DevOps"
  }
}

output "repository_url" {
  value = module.ecr_repo.repository_url
}

output "registry_id" {
  value = module.ecr_repo.registry_id
}

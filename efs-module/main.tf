resource "aws_efs_file_system" "efs_volume" {
  creation_token = var.efs_name
  tags = {
    Name = var.efs_name
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  performance_mode = "generalPurpose"
  encrypted = true

  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
}

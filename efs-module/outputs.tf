output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.this.dns_name
}

output "efs_mount_target_ids" {
  value = aws_efs_file_system.this.mount_target_ids
}

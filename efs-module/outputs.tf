output "efs_id" {
  value = aws_efs_file_system.efs_volume.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.efs_volume.dns_name
}

output "efs_mount_target_ids" {
  value = aws_efs_file_system.efs_volume.mount_target_ids
}

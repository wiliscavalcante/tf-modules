output "nlb_arn" {
  description = "ARN do Network Load Balancer"
  value       = aws_lb.network.arn
}

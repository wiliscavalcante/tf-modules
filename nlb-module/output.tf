output "nlb_arn" {
  description = "ARN do Network Load Balancer"
  value       = aws_lb.network.arn
}

output "dns_name" {
  description = "Nome DNS do NLB"
  value       = aws_lb.internal_nlb.dns_name
}

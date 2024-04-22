variable "project_name" {
  description = "The name of the project for tagging and resource naming."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instances."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
}

variable "key_name" {
  description = "The key name to use for SSH access."
  type        = string
}

variable "volume_size" {
  description = "The size of the EBS volume."
  type        = number
}

variable "kms_key_id" {
  description = "The KMS key ID for EBS encryption."
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to assign to the instances."
  type        = string
  default = ""
}

variable "iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile to associate with the instances."
  type        = string
}

variable "user_data" {
  description = "The Base64 encoded user data script."
  type        = string
  default     = ""
}


variable "min_size" {
  description = "The minimum size of the Auto Scaling Group."
  type        = number
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group."
  type        = number
}

variable "desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group."
  type        = number
}

variable "subnets" {
  description = "A list of subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "required_tags" {
  description = "A map of required tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "env" {
  description = "The deployment environment for the resource. Common environments include 'dev', 'test', 'staging', and 'prod'."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC where resources will be created."
  type        = string
  default = ""
}

variable "aws_account_id" {
  description = "The AWS Account ID where the KMS key is used."
  type        = string
  default = ""
}
variable "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate from AWS Certificate Manager (ACM) to be used with the ALB."
  type        = string
  default = ""
}

variable "alb_internal" {
  description = "Defines if the ALB should be internal. Set to true for internal, false for public-facing."
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "The port on which the targets receive traffic."
  type        = number
  default     = 443
}

variable "target_group_protocol" {
  description = "The protocol to use for routing traffic to the targets."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The destination for the health check requests."
  type        = string
  default     = "/"
}

variable "ssl_policy" {
  description = "The SSL policy to use for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

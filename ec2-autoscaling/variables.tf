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

# variable "kms_key_id" {
#   description = "The KMS key ID for EBS encryption."
#   type        = string
# }

variable "security_group_id" {
  description = "The security group ID to assign to the instances."
  type        = string
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

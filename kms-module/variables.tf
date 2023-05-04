variable "description" {
  type    = string
  default = "Example KMS Key"
}

variable "policy" {
  type    = string
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "key_rotation_period" {
  type    = string
  default = "1y"
}

variable "customer_master_key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}

variable "tags" {
  type    = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

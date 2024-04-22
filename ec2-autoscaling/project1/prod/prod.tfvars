project_name             = "projeto1"
ami_id                   = "ami-0e242b0ebd8e91b4c"
instance_type            = "t3.medium"
key_name                 = "key_linux_becompliance"
volume_size              = 50
kms_key_id               = "arn:aws:kms:sa-east-1:615519303364:key/04d49912-159e-4203-970f-fcb39530245c"
# kms_key_id               = ""
# security_group_id        = "sg-08204d3a12073deb6"
security_group_id        = ""
# iam_instance_profile_arn = "arn:aws:iam::615519303364:instance-profile/RoleForEc2"
iam_instance_profile_arn = ""
min_size                 = 1
max_size                 = 1
desired_capacity         = 1
# subnets                  = ["subnet-08d47e590ecc0f621", "subnet-0bc945ea6d09519bc"]
env                      = "dev"
ssl_certificate_arn = "arn:aws:acm:sa-east-1:615519303364:certificate/a0d0a701-7065-40ae-aafc-76845b3407e0"
alb_internal = false
health_check_path = "/"
target_group_port = 443
target_group_protocol = "HTTPS"

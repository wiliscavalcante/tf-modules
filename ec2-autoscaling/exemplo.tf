#tariables.tfvars

project_name            = "projeto1"
ami_id                  = "ami-0e242b0ebd8e91b4c"
instance_type           = "t3.medium"
key_name                = "key_linux_becompliance"
volume_size             = 50
# kms_key_id              = "arn:aws:kms:sa-east-1:615519303364:key/04d49912-159e-4203-970f-fcb39530245c"
security_group_id       = "sg-08204d3a12073deb6"
iam_instance_profile_arn= "arn:aws:iam::615519303364:instance-profile/RoleForEc2"
min_size                = 1
max_size                = 1
desired_capacity        = 1
subnets                 = ["subnet-08d47e590ecc0f621", "subnet-0bc945ea6d09519bc"]


#main.tf

module "ec2_autoscaling" {
  source = "../../modules/ec2-autoscaling"

  project_name            = var.project_name
  ami_id                  = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  volume_size             = var.volume_size
  # kms_key_id              = var.kms_key_id
  security_group_id       = var.security_group_id
  iam_instance_profile_arn= var.iam_instance_profile_arn
  user_data                = filebase64("user_data.sh")
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  subnets                 = var.subnets
}

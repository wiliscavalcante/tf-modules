resource "aws_launch_template" "app" {
  name_prefix   = "lt-${var.project_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  block_device_mappings {
    # Configuração para o volume raiz
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = "gp3"
      encrypted   = true
    }
  }

  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        "Name" = "instance-${var.project_name}"
      },
      var.required_tags
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      {
        "Name" = "volume-${var.project_name}"
      },
      var.required_tags
    )
  }

  user_data = var.user_data

  # Automaticamente atualiza a versão default para a versão mais recente do template
  update_default_version = true
}


resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = var.subnets

  dynamic "tag" {
    for_each = merge(
      {
        "Name" = "ASG-${var.project_name}"  
      },
      var.required_tags
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

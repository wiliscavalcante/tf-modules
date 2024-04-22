resource "aws_launch_template" "app" {
  name_prefix   = "lt-${var.project_name}-${var.env}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = "gp3"
      encrypted   = true
      kms_key_id  = var.kms_key_id != "" ? var.kms_key_id : aws_kms_key.default[0].arn
    }
  }

  vpc_security_group_ids = length(var.security_group_id) > 0 ? [var.security_group_id] : [aws_security_group.default[0].id]

  iam_instance_profile {
  name = var.iam_instance_profile_arn != "" ? split("/", var.iam_instance_profile_arn)[1] : aws_iam_instance_profile.default[0].name
}

  tag_specifications {
    resource_type = "instance"
    tags = var.required_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags = var.required_tags
  }

  user_data = var.user_data
  update_default_version = true
}

resource "aws_autoscaling_group" "app" {
  name                      = "ASG-${var.project_name}-${var.env}"
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = var.subnets

  dynamic "tag" {
    for_each = var.required_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  
   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
      instance_warmup        = 120
      auto_rollback          = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

resource "aws_lb" "app_alb" {
  name               = "alb-${var.project_name}-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [length(var.security_group_id) > 0 ? var.security_group_id : aws_security_group.default[0].id]
  subnets            = var.subnets

  tags = var.required_tags
}

resource "aws_lb_target_group" "app_tg" {
  name     = "tg-${var.project_name}-${var.env}"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = var.health_check_path
    protocol            = var.target_group_protocol
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = var.required_tags
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}




resource "aws_security_group" "default" {
  count       = var.security_group_id == "" ? 1 : 0
  name        = "${var.project_name}-${var.env}-sg"
  description = "Security group for ${var.project_name} in ${var.env} environment."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "HTTPS access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from anywhere."
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

resource "aws_kms_key" "default" {
  count                   = var.kms_key_id == "" ? 1 : 0
  description             = "KMS Key for encrypting EBS volumes for ${var.project_name} in ${var.env}"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms_policy.json
  tags = var.required_tags
}

resource "aws_kms_alias" "default" {
  count          = var.kms_key_id == "" ? 1 : 0
  name           = "alias/auto-scaling-encryption-${var.env}"
  target_key_id  = aws_kms_key.default[0].id
}


data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid       = "Allow administration of the key"
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid       = "Allow service-linked role use of the customer managed key"
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "Allow attachment of persistent resources"
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
  
}

resource "aws_iam_role" "default" {
  count = var.iam_instance_profile_arn == "" ? 1 : 0
  name  = "RoleFor-${var.project_name}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ssm" {
  count      = var.iam_instance_profile_arn == "" ? 1 : 0
  name       = "PolicyFor-ssm-policy-attachment-${var.project_name}-${var.env}"
  roles      = [aws_iam_role.default[0].name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "default" {
  count = var.iam_instance_profile_arn == "" ? 1 : 0
  name  = "${var.project_name}-${var.env}-ec2-profile"
  role  = aws_iam_role.default[0].name
}
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}
# resource "aws_ecr_lifecycle_policy" "this" {
#   count = var.enable_lifecycle_policy ? 1 : 0
#   repository = aws_ecr_repository.this.name

#   policy = <<EOF
# {
#     "rules": [
#         {
#             "rulePriority": 1,
#             "description": "Keep last 30 images",
#             "selection": {
#                 "tagStatus": "tagged",
#                 "tagPrefixList": ["v"],
#                 "countType": "imageCountMoreThan",
#                 "countNumber": 30
#             },
#             "action": {
#                 "type": "expire"
#             }
#         }
#     ]
# }
# EOF
# }
resource "aws_ecr_lifecycle_policy" "this" {
  count = var.enable_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep images for ${var.days_to_keep} days"
        selection    = {
          tagStatus    = "tagged"
          countType    = "sinceImagePushed"
          countNumber  = var.days_to_keep
          countUnit    = "days"
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })
}

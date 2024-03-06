###dynamodb.tf

resource "aws_iam_role_policy" "application_policy_dynamodb" {
  count = length(var.dynamodb_tables) > 0 ? 1 : 0
  name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}DynamoDB"
  role  = aws_iam_role.application_role.id


  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
    for table in var.dynamodb_tables :
    {
      Effect = "Allow"
      Action = flatten([
        [
          "dynamodb:DescribeTable",
        ],
        table.permission.select ? [
          "dynamodb:BatchGetItem",
          "dynamodb:Scan",
          "dynamodb:ListTagsOfResource",
          "dynamodb:Query",
          "dynamodb:PartiQLSelect",
          "dynamodb:GetItem"
        ] : [],
        table.permission.insert ? [
          "dynamodb:PutItem",
          "dynamodb:PartiQLInsert"
        ] : [],
        table.permission.update ? [
          "dynamodb:PartiQLUpdate",
          "dynamodb:UpdateItem",
        ] : [],
        table.permission.delete ? [
          "dynamodb:DeleteItem",
          "dynamodb:PartiQLDelete"
        ] : [],
        table.permission.admin ? [
          "dynamodb:DeleteTable",
          "dynamodb:CreateTable",
          "dynamodb:UpdateTable"
        ] : []
      ])
      Resource = [
        "arn:aws:dynamodb:${table.region}:${var.account_id}:table/${table.name}"
      ]
    }
    ]
  })
}

###kms.tf

resource "aws_iam_role_policy" "application_policy_kms" {
  count = length(var.kms_keys) > 0 ? 1 : 0
  name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}KMS"
  role  = aws_iam_role.application_role.id


  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
    for key in var.kms_keys :
    {
      Effect = "Allow"
      Action = flatten([
        [
          "kms:GetPublicKey",
          "kms:ListResourceTags",
          "kms:GetParametersForImport",
          "kms:GetKeyRotationStatus",
          "kms:DescribeKey",
          "kms:ListKeyPolicies",
          "kms:ListRetirableGrants",
          "kms:GetKeyPolicy",
          "kms:ListGrants"
        ],
        key.permission.encrypt ? [
          "kms:Encrypt",
          "kms:ReEncryptTo",
          "kms:ReEncryptFrom",
          "kms:GenerateDataKey",
        ] : [],
        key.permission.decrypt ? [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ] : []
      ])
      Resource = [
        try(
          key.id.arn,
          try(key.id.alias, null) != null ? "*" : "arn:aws:kms:${key.id.region}:${var.account_id}:key/${key.id.key}"
        )
      ]
      Condition = try(key.id.alias, null) != null ? {
        "ForAnyValue:StringEquals" = {
          "kms:ResourceAliases" = "alias/${trimprefix(key.id.alias, "alias/")}"
        }
      } : {}
    }
    ]
  })
}

###lambda.tf
resource "aws_iam_role_policy" "lambda_invoke_policy" {
  count = length(var.lambda_functions) > 0 ? 1 : 0
  name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}Lambda"
  role  = aws_iam_role.application_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      for lambda_function in var.lambda_functions : {
        Effect = "Allow",
        Action = flatten([
          [
            "lambda:GetFunction",
            "lambda:GetFunctionConfiguration"
          ],
          lambda_function.permission.invoke ? [
            "lambda:InvokeFunctionUrl",
            "lambda:InvokeFunction",
            "lambda:InvokeAsync"
          ] : [],
        ])
        Resource = "arn:aws:lambda:${lambda_function.id.region}:${coalesce(lambda_function.id.account_id, var.account_id)}:function:${lambda_function.id.name}"
      }
    ]
  })
}

###outputs.tf

output "application_role" {
    value = aws_iam_role.application_role
  }

###role.tf

resource "aws_iam_role" "application_role" {
    name = "BURoleFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}${upper(var.env)}"
  
    assume_role_policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_provider}"
          }
          Action    = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${var.oidc_provider}:aud" = "sts.amazonaws.com",
              "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:${var.app_name}"
            }
          }
        },
      ]
    })
  
    permissions_boundary = "arn:aws:iam::${var.account_id}:policy/BUAdminBasePolicy"
  
    tags = merge(
      var.extra_tags,
      {
        Terraformed = "true"
      })
  }

  ###s3.tf

  resource "aws_iam_role_policy" "application_policy_s3" {
    count = length(var.s3_buckets) > 0 ? 1 : 0
    name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}S3"
    role  = aws_iam_role.application_role.id
  
  
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
      for bucket in var.s3_buckets :
      {
        Effect = "Allow"
        Action = flatten([
          bucket.permission.read ? [
            "s3:ListBucket",
            "s3:GetObjectAttributes",
            "s3:GetBucketAcl",
            "s3:GetObjectAcl",
            "s3:GetObject",
            "s3:GetObjectTagging",
            "s3:GetBucketLocation",
            "s3:GetObjectVersion"
          ] : [],
          bucket.permission.write ? [
            "s3:ListBucketMultipartUploads",
            "s3:PutObjectLegalHold",
            "s3:PutObject",
            "s3:AbortMultipartUpload"
          ] : [],
          bucket.permission.delete ? [
            "s3:DeleteObject"
          ] : []
        ])
        Resource = [
          "arn:aws:s3:::${bucket.name}",
          "arn:aws:s3:::${bucket.name}/*"
        ]
      }
      ]
    })
  }

###secrets-manager.tf

resource "aws_iam_role_policy" "application_policy_secrets_manager" {
    count = length(var.secrets) > 0 ? 1 : 0
    name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}SecretsManager"
    role  = aws_iam_role.application_role.id
  
  
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
      for secret in var.secrets :
      {
        Effect = "Allow"
        Action = flatten([
          secret.permission.read ? [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue"
          ] : []
        ])
        Resource = [
          try(
            secret.id.arn,
            "arn:aws:secretsmanager:${secret.id.region}:${var.account_id}:secret:${secret.id.name}-??????"
          )
        ]
      }
      ]
    })
  }

###sqs.tf

resource "aws_iam_role_policy" "application_policy_sqs" {
    count = length(var.sqs_queues) > 0 ? 1 : 0
    name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}SQS"
    role  = aws_iam_role.application_role.id
  
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
      for queue in var.sqs_queues :
      {
        Effect = "Allow"
        Action = flatten([
          [
            "sqs:GetQueueUrl",
            "sqs:GetQueueAttributes",
          ],
          queue.permission.send ? [
            "sqs:ChangeMessageVisibility",
            "sqs:SendMessage"
          ] : [],
          queue.permission.receive ? [
            "sqs:DeleteMessage",
            "sqs:ChangeMessageVisibility",
            "sqs:ReceiveMessage",
            "sqs:SetQueueAttributes"
          ] : []
        ])
        Resource = [
          "arn:aws:sqs:${queue.region}:${var.account_id}:${queue.name}"
        ]
      }
      ]
    })
  }

###variables.tf

variable "account_id" {
    type = string
  }
  
  variable "env" {
    type = string
  }
  
  variable "namespace" {
    type = string
  }
  
  variable "app_name" {
    type = string
  }
  
  variable "oidc_provider" {
    type = string
  }
  
  variable "extra_tags" {
    type    = map(string)
    default = {}
  }
  
  variable "sqs_queues" {
    type = list(
      object({
        name       = string
        region     = string
        permission = object({
          send    = bool
          receive = bool
        })
      }))
    default = []
  }
  
  variable "sns_regions_send_sms" {
    type    = list(string)
    default = []
  }
  
  variable "sns_topics" {
    type = list(
      object({
        name       = string
        region     = string
        permission = object({
          publish = bool
        })
      }))
    default = []
  }
  
  variable "s3_buckets" {
    type = list(
      object({
        name       = string
        permission = object({
          read   = bool
          write  = bool
          delete = bool
        })
      }))
    default = []
  }
  
  variable "aws_keyspaces" {
    type = list(
      object({
        name       = string
        region     = string
        tables     = list(string)
        permission = object({
          select               = bool
          insert_update_delete = bool
          create_alter_table   = bool
          admin                = bool
        })
      }))
    default = []
  }
  
  variable "dynamodb_tables" {
    type = list(
      object({
        name       = string
        region     = string
        permission = object({
          select = bool
          insert = bool
          update = bool
          delete = bool
          admin  = bool
        })
      }))
    default = []
  }
  
  variable "kms_keys" {
    type = list(
      object({
        id         = map(string)
        permission = object({
          encrypt = bool
          decrypt = bool
        })
      }))
    default = []
  }
  
  variable "secrets" {
    type = list(
      object({
        id         = map(string)
        permission = object({
          read = bool
        })
      }))
    default = []
  }
  
  variable "lambda_functions" {
    type = list(
      object({
        id = object({
          name       = string
          region     = string
          account_id = string
        })
        permission = object({
          invoke = bool
        })
      }))
    default = []
  }
########################

variable "service" {
  description = "O serviço AWS que pode assumir esta role, se diferente de EKS."
  type        = string
  default     = ""
}

resource "aws_iam_role" "application_role" {
  name = "BURoleFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}${upper(var.env)}"

  assume_role_policy = var.service != "" ? jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "${var.service}.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  }) : jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS       = "arn:aws:iam::${var.account_id}:root",
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_provider}"
        },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:aud" = "sts.amazonaws.com",
            "${var.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:${var.app_name}"
          }
        }
      }
    ]
  })

  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/BUAdminBasePolicy"

  tags = merge(
    var.extra_tags,
    {
      Terraformed = "true"
    }
  )
}

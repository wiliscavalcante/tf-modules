# role.tf
resource "aws_iam_role" "application_role" {
  name = "BURoleFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}${upper(var.env)}"


  assume_role_policy = local.is_eks ? jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${local.eks.oidc_provider}"
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.eks.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.eks.oidc_provider}:sub" = "system:serviceaccount:${local.eks.namespace}:${var.app_name}"
          }
        }
      },
    ]
  }) : jsonencode({
    Version   = "2012-10-17",
    Statement = [
      for aws_service in var.aws.services :
      {
        Effect    = "Allow",
        Principal = {
          Service = "${aws_service}.amazonaws.com"
        },
        Action = "sts:AssumeRole"
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

# variables.tf

variable "account_id" {
  type = string
}

variable "env" {
  type = string
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Use the object EKS.namespace"
}

variable "app_name" {
  type = string
}

variable "oidc_provider" {
  type        = string
  default     = ""
  description = "Use the object EKS.oidc_provider"
}

variable "eks" {
  type = object({
    namespace     = string
    oidc_provider = string
  })

  default = {
    namespace     = ""
    oidc_provider = ""
  }
}

variable "aws" {
  type = object({
    services = list(string)
  })

  default = {
    services = []
  }
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

variable "cloudwatch_logs" {
  type = list(
    object({
      id = object({
        logGroup   = string
        logStream  = string
        region     = string
        region     = string
        account_id = string
      })
      permission = object({
        put = bool
      })
    }))
  default = []
}

# s3.tf

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

# cloudwatch-logs.tf

resource "aws_iam_role_policy" "application_policy_cloudwatch_logs" {
  count = length(var.cloudwatch_logs) > 0 ? 1 : 0
  name  = "BUPolicyFor${replace(title(replace(var.app_name, "-", " ")), " ", "")}CloudWatchLogs"
  role  = aws_iam_role.application_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      for logs in var.cloudwatch_logs :
      {
        Effect = "Allow",
        Action = flatten([
          logs.permission.put ? [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ] : []
        ])
        Resource = [
          "arn:aws:logs:${logs.id.region}:${logs.id.account_id}:log-group:${logs.id.logGroup}",
          "arn:aws:logs:${logs.id.region}:${logs.id.account_id}:log-group:${logs.id.logGroup}:log-stream:${logs.id.logStream}"
        ]
      }
    ]
  })
}

# Exemplo de uso:

# permissions.tf

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "application_permissions" {
  source = "./"

  account_id    = data.aws_caller_identity.current.account_id
  env           = var.env
  app_name      = local.app_name

   s3_buckets = [
     for bucket_name in var.s3_bucket_names : {
       name       = bucket_name
       permission = {
         read   = true
         write  = true
         delete = false
       }
     }
   ]

   secrets = [
    for secret_name in var.secrets_names : {
      id       = {
        name = secret_name
        region = local.region
      }
      permission = {
        read   = true
      }
    }
   ]

   cloudwatch_logs = [
     for cloudwatch_log in var.cloudwatch_logs : {
       id       = {
        logGroup   = string
        logStream  = string
        region     = local.region
        account_id = string
      }
       permission = {
        put   = true
      }
     }
   ]

  extra_tags = {
    Application = local.app_name
    Env         = var.ENV
  }  
}

# variables-devicePixelRatio.tfvars

env              = "dev"

# s3_bucket_names = [
#     "public-warehouse-dev"
# ]

secrets_names = [
    "SM_AGROWATCH_SETTINGS_DEV",
    "SM_DB_BRAIN_PUBLIC_DEV",
    "SM_BRAIN_AES_ENCRYPTION_KEYS_V1"
]

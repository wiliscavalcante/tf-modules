
provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "s3_bucket_01" {
  source = "github.com/wiliscavalcante/tf-modules.git//s3-bucket-module"

  bucket_name = "bucket-terraform-01"
  force_destroy = true
  tags          = var.tags

}

module "s3_bucket_02" {
  source = "github.com/wiliscavalcante/tf-modules.git//s3-bucket-module"

  bucket_name = "bucket-terraform-02"
  force_destroy = true
  tags          = var.tags

}


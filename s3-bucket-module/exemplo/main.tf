
provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

module "s3_bucket" {
  source = "../"

  count  = length(var.s3_bucket_names) 
  bucket = var.s3_bucket_names[count.index]
  force_destroy = true
  tags          = var.tags

}


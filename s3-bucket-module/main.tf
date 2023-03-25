########################
# Bucket creation
########################

resource "aws_s3_bucket" "this" {

  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags

}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.enable_sse ? var.sse_algorithm : "AES256"
      kms_master_key_id = var.enable_sse ? var.kms_master_key_id : null
    }
  }
}

##########################
# Bucket private access
##########################

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.acl

}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  payer  = var.request_payer
}


#############################
# Enable bucket versioning
#############################
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning
  }
}


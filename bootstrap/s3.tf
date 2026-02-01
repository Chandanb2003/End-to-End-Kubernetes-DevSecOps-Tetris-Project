resource "aws_s3_bucket" "tf" {
  bucket = "chandan-tf"

  tags = {
    Name = "terraform-backend"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf.id

  versioning_configuration {
    status = "Enabled"
  }
}


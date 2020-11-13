resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_name}-site-logs"
  acl = "log-delivery-write"
}

resource "aws_s3_bucket" "storefront_bucket" {
  bucket = "storefront.${var.domain_name}"
  acl    = "public-read"

  policy = <<EOF
{
  "Id": "MakePublicID",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Sid1",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::storefront.${var.domain_name}/*",
      "Principal": "*"
    },
    {
      "Sid": "Sid2",
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::storefront.${var.domain_name}",
      "Principal": "*"
    }
  ]
}
EOF
  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "storefront.${var.domain_name}/"
  }
  website {
    index_document = "index.html"
  }
}
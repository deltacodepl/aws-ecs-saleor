output "alb_hostname" {
  value = aws_lb.production.dns_name
}

output "storefront_bucket" {
  value = aws_s3_bucket.storefront_bucket
}

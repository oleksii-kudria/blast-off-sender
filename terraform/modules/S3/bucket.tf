resource "aws_s3_bucket" "blast-off-sender" {
    bucket = "${var.bucket_name}" 
    acl = "${var.acl_value}"   
}
# infrastructure/terraform/aws/main.tf
# Terraform configuration for AWS.
# For now, it's a placeholder.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

terraform {
  backend "s3" {
    bucket         = "x-company-terraform-state-bucket-2025-fawry-intern"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "x-company-terraform-lock-table-2025-fawry-intern"
    encrypt        = true
  }
}


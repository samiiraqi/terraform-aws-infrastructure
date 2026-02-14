terraform {
  backend "s3" {
    bucket         = "tf-demo-state-bucket-unique-2026"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-demo-locks"
    encrypt        = true
  }
}

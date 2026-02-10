terraform {
  backend "s3" {
    bucket         = "bedrock-tfstate-1288"
    key            = "project-bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-tf-lock-1288"
    encrypt        = true
  }
}

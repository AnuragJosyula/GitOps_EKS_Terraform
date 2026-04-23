terraform {
  backend "s3" {
    bucket       = "dante-bucket-tfstate"
    key          = "dev/terraform.tfstate"
    use_lockfile = true
    region       = "us-east-1"
  }
}


terraform {
  backend "s3" {
    bucket         = "hello-birthday-api-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile    = true
  }
}

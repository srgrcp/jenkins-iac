terraform {
  backend "s3" {
    bucket = "srgrcp-terraform-00"
    key    = "terraform/jenkins-iac.tfstate"
    region = "us-east-1"
  }
}

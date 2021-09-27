terraform {
  backend "s3"{
    bucket         = "tf-state-bucket-1115"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
  }

  required_providers {
    aws = ">=3.38.0"
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-states72"
    key    = "main-infra/terraform.tfstate"
    region = "us-west-2"
	dynamodb_table = "terraform-locks"
	encrypt= true
  }
}


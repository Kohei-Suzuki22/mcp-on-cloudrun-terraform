terraform {
  backend "gcs" {
    bucket = "szkou-my-tfstate"
    prefix = "mcp-on-cloudrun-terraform"
    impersonate_service_account = "szkou-my-terraform@szkou-my-terraform.iam.gserviceaccount.com"
  }
}
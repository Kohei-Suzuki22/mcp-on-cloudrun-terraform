terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "PROACTIVE"
  access_token                                  = data.google_service_account_access_token.tf_access_token.access_token
  request_timeout                               = "300s"
  default_labels = {
    "created_by"     = "terraform",
    "terraform_repo" = "mcp-on-cloudrun-terraform"
  }

  region = "asia-northeast1"
}

provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  default_labels = {
    "created_by"     = "terraform",
    "terraform_repo" = "mcp-on-cloudrun-terraform"
  }
}
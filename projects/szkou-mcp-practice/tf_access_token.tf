data "google_service_account_access_token" "tf_access_token" {
  provider = google.impersonate
  target_service_account = "szkou-my-terraform@szkou-my-terraform.iam.gserviceaccount.com"
  scopes = ["userinfo-email", "cloud-platform"]
  lifetime = "1200s"
}
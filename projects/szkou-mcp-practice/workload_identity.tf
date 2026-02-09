# GitHub Actions 用 Service Account
resource "google_service_account" "github_actions" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer"
  description  = "Service account for GitHub Actions CI/CD"
  project      = "szkou-my-terraform"
}

# Artifact Registry への push 権限 (szkou-mcp-practice プロジェクトに対して)
resource "google_project_iam_member" "github_actions_ar_writer" {
  project = "szkou-mcp-practice"
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Cloud Run へのデプロイ権限 (szkou-mcp-practice プロジェクトに対して)
resource "google_project_iam_member" "github_actions_run_developer" {
  project = "szkou-mcp-practice"
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Cloud Run のサービスアカウントを使用する権限 (szkou-mcp-practice プロジェクトに対して)
resource "google_project_iam_member" "github_actions_sa_user" {
  project = "szkou-mcp-practice"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Workload Identity Pool
resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
  project                   = "szkou-my-terraform"
}

# Workload Identity Pool Provider (GitHub Actions OIDC)
resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC provider for GitHub Actions"
  project                            = "szkou-my-terraform"

  attribute_condition = "assertion.repository == \"Kohei-Suzuki22/mcp-on-cloudrun-app\""

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# GitHub Actions から Service Account を impersonate するための IAM バインディング
resource "google_service_account_iam_member" "github_actions_wif" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/Kohei-Suzuki22/mcp-on-cloudrun-app"
}

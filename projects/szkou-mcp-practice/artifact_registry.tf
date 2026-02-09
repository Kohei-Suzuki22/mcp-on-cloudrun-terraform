resource "google_artifact_registry_repository" "mcp_on_cloudrun_app" {
  location      = "asia-northeast1"
  repository_id = "mcp-on-cloudrun-app"
  description   = "Docker repository for mcp-on-cloudrun-app"
  format        = "DOCKER"
  project       = "szkou-mcp-practice"
}

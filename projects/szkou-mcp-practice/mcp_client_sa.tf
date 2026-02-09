# MCP クライアント用 Service Account
resource "google_service_account" "mcp_client" {
  account_id   = "mcp-client"
  display_name = "MCP Client"
  description  = "Service account for MCP client authentication to Cloud Run"
  project      = "szkou-mcp-practice"
}

# Cloud Run サービスへの invoker 権限
resource "google_cloud_run_v2_service_iam_member" "mcp_client_invoker" {
  name     = google_cloud_run_v2_service.mcp_on_cloudrun_app.name
  location = google_cloud_run_v2_service.mcp_on_cloudrun_app.location
  project  = "szkou-mcp-practice"
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.mcp_client.email}"
}

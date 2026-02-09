
########
#### コスト削減のために、使わないときはコメントアウトし、リソースを削除する。
####必要な時にコメントアウト解除し、リソースを作成すること。
########




# resource "google_cloud_run_v2_service" "mcp_on_cloudrun_app" {
#   name                 = "mcp-on-cloudrun-app"
#   location             = "asia-northeast1"
#   project              = "szkou-mcp-practice"
#   deletion_protection  = false
#   ingress              = "INGRESS_TRAFFIC_ALL"
#   invoker_iam_disabled = false

#   scaling {
#     min_instance_count    = 0
#     manual_instance_count = 0
#   }

#   template {
#     scaling {
#       min_instance_count = 0
#       max_instance_count = 1
#     }

#     containers {
#       image = "us-docker.pkg.dev/cloudrun/container/hello"
#       resources {
#         limits = {
#           cpu = "1"
#           memory = "1Gi"
#         }

#       }
#     }

#   }

#   lifecycle {
#     ignore_changes = [
#       template[0].containers[0].image,
#       template[0].labels,
#       client,
#       client_version,
#     ]
#   }
# }

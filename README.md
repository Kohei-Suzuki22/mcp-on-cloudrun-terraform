# mcp-on-cloudrun-terraform

Cloud Run 上の MCP サーバーを構成するための Terraform リポジトリ。

## 関連リポジトリ

アプリケーションコードは別リポジトリで管理しています：

- [mcp-on-cloudrun-app](https://github.com/Kohei-Suzuki22/mcp-on-cloudrun-app) — MCP サーバーのアプリケーションコード、Dockerfile、GitHub Actions ワークフロー

## GCP プロジェクト構成

| プロジェクト | 用途 |
|--------------|------|
| `szkou-my-terraform` | Terraform SA、Workload Identity Federation、GitHub Actions SA |
| `szkou-mcp-practice` | Artifact Registry、Cloud Run、MCP クライアント SA |

## Terraform ファイル構成

| ファイル | 説明 |
|----------|------|
| `providers.tf` | Google プロバイダー設定（SA impersonation による認証） |
| `backend.tf` | GCS バックエンド（`szkou-my-tfstate` バケット） |
| `tf_access_token.tf` | Terraform 用アクセストークンの取得 |
| `artifact_registry.tf` | Docker リポジトリ（`mcp-on-cloudrun-app`） |
| `cloud_run.tf` | Cloud Run v2 サービス（scale-to-zero 構成） |
| `workload_identity.tf` | GitHub Actions 用 Workload Identity Federation |
| `mcp_client_sa.tf` | MCP クライアント用 SA |
| `local_env.tf` | ローカル変数 |

## リソース概要

### Artifact Registry

- `mcp-on-cloudrun-app` — Docker リポジトリ（asia-northeast1）

### Cloud Run

- `mcp-on-cloudrun-app` — MCP サーバー（asia-northeast1、scale-to-zero）
- IAM 認証必須（`invoker_iam_disabled = false`）

### Workload Identity Federation（szkou-my-terraform プロジェクト）

GitHub Actions から Google Cloud へのキーレス認証を構成：

- `github-actions-deployer` SA
- `github-actions-pool` Workload Identity Pool
- `github-actions-provider` OIDC Provider（GitHub Actions 用）
- 対象リポジトリ: `Kohei-Suzuki22/mcp-on-cloudrun-app`

### MCP クライアント SA

- `mcp-client@szkou-mcp-practice.iam.gserviceaccount.com`
- 認証検証用のサービスアカウント
- `roles/run.invoker` を付与/剥奪することで認証の成功/失敗をテスト可能

## 使い方

```bash
terraform init
terraform plan
terraform apply
```

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "csi/db-credentials"
  description = "Database credentials for CSI applications"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "REPLACE_WITH_SECURE_PASSWORD"
    host     = "db.example.com"
    port     = 5432
    dbname   = "csidb"
  })
}

resource "aws_secretsmanager_secret" "api_keys" {
  name        = "csi/api-keys"
  description = "API keys for external services"
}

resource "aws_secretsmanager_secret_version" "api_keys" {
  secret_id     = aws_secretsmanager_secret.api_keys.id
  secret_string = jsonencode({
    service_a_key = "REPLACE_WITH_SERVICE_A_KEY"
    service_b_key = "REPLACE_WITH_SERVICE_B_KEY"
  })
}
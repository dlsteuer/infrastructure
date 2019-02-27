provider "google" {
  region = "us-west1"
}

terraform {
  backend "gcs" {
    bucket = "terraform-battlesnake-io"
    prefix = "battlesnake/k8s_secrets_tournament"
  }

  required_version = "= 0.11.7"
}

provider "kubernetes" {
  
}

data "terraform_remote_state" "sql-tournament" {
  backend   = "gcs"
  config {
    bucket  = "terraform-battlesnake-io"
    prefix  = "battlesnake/sql-tournament"
  }
}

resource "kubernetes_secret" "cloudsql-engine-tournament-instance-credentials" {
  metadata {
    name               = "cloudsql-engine-tournament-instance-credentials"
    namespace          = "engine-tournament"
  }
  data {
    "credentials.json" = "${base64decode(data.terraform_remote_state.sql-tournament.cloudsqlproxy-engine-tournament-service-account-private-key)}"
  }
}

resource "kubernetes_secret" "cloudsql-engine-tournament-db-credentials" {
  metadata {
    name       = "cloudsql-engine-tournament-db-credentials"
    namespace  = "engine-tournament"
  }
  data {
    username   = "${data.terraform_remote_state.sql-tournament.db_user_name_engine_tournament}"
    password   = "${data.terraform_remote_state.sql-tournament.generated_user_password_engine_tournament}"
  }
}

resource "kubernetes_secret" "cloudsql-engine-tournament-db-config" {
  metadata {
    name              = "cloudsql-engine-tournament-db-config"
    namespace         = "engine-tournament"
  }
  data {
    connection_name   = "${data.terraform_remote_state.sql-tournament.connection_name_engine_tournament}"
    instance_address  = "${data.terraform_remote_state.sql-tournament.instance_address_engine_tournament}"
    instance_name     = "${data.terraform_remote_state.sql-tournament.instance_name_engine_tournament}"
  }
}

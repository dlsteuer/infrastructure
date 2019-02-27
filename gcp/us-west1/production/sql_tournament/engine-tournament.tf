module "postgresql-engine-tournament" {
  source                      = "../../../../modules/gcp/sql"

  project                     = "battlesnake-io"

  name                        = "battlesnake-engine-tournament"
  database_version            = "POSTGRES_9_6"
  region                      = "us-west1"
  tier                        = "db-custom-16-65536" # 16 CPU, 64GB ram
  activation_policy           = "ALWAYS"
  availability_type           = "REGIONAL"
  disk_autoresize             = "true"
  disk_size                   = "100"
  disk_type                   = "PD_SSD"
  ip_configuration            = [{
    ipv4_enabled  = "true"
  }]
  backup_configuration        = [{
    enabled = "true"
    start_time = "00:00"
  }]
  maintenance_window          = [{
    day = "7"
    hour = "23"
    update_track = "stable"
  }]

  db_name                     = "engine"
  db_charset                  = "UTF8"
  db_collation                = "en_US.UTF8"

}

module "db-user-engine-tournament" {
  source    = "../../../../modules/gcp/sql_user"

  project   = "battlesnake-io"

  user_name = "proxyuser"
  instance = "${module.postgresql-engine-tournament.instance_name}"
  
}

module "cloudsqlproxy-engine-tournament-service-account" {
  source        = "../../../../modules/gcp/service_account"
  
  account_id    = "cloudsqlproxy-enginetournament"
  display_name  = "cloudsqlproxy-enginetournament"
  project       = "battlesnake-io"
}

module "cloudsqlproxy-engine-tournament-service-account-key" {
  source = "../../../../modules/gcp/service_account_key"

  service_account_id = "${module.cloudsqlproxy-engine-tournament-service-account.name}"
}

module "cloudsqlproxy-engine-tournament-binding-cloudsql-client" {
  source                = "../../../../modules/gcp/project_iam_binding"

  project               = "battlesnake-io"

  role                  = "roles/cloudsql.client"
  member                = "serviceAccount:${module.cloudsqlproxy-engine-tournament-service-account.email}"
}

module "cloudsqlproxy-engine-tournament-binding-cloudsql-editor" {
  source                = "../../../../modules/gcp/project_iam_binding"
  
  project               = "battlesnake-io"

  role                  = "roles/cloudsql.editor"
  member                = "serviceAccount:${module.cloudsqlproxy-engine-tournament-service-account.email}"
}

module "cloudsqlproxy-engine-tournament-binding-cloudsql-admin" {
  source                = "../../../../modules/gcp/project_iam_binding"

  project               = "battlesnake-io"

  role                  = "roles/cloudsql.admin"
  member                = "serviceAccount:${module.cloudsqlproxy-engine-tournament-service-account.email}"
}

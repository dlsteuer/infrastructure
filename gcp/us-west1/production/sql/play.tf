module "postgresql-play" {
  source                      = "../../../../modules/gcp/sql"

  project                     = "battlesnake-io"

  name                        = "battlesnake-play"
  database_version            = "POSTGRES_9_6"
  region                      = "us-west1"
  tier                        = "db-custom-2-4096" # 2 CPU, 4GB ram
  activation_policy           = "ALWAYS"
  availability_type           = "REGIONAL"
  disk_autoresize             = "true"
  disk_size                   = "100"
  disk_type                   = "PD_SSD"
  backup_configuration        = [{
    enabled = "true"
    start_time = "00:00"
  }]
  maintenance_window          = [{
    day = "7"
    hour = "23"
    update_track = "stable"
  }]

  db_name                     = "play"
  db_charset                  = "UTF8"
  db_collation                = "en_US.UTF8"

}

module "db-user" {
  source    = "../../../../modules/gcp/sql_user"

  project   = "battlesnake-io"

  user_name = "proxyuser"
  instance = "${module.postgresql-play.instance_name}"
  
}

module "cloudsqlproxy-play-service-account" {
  source        = "../../../../modules/gcp/service_account"
  
  account_id    = "cloudsqlproxy-play"
  display_name  = "cloudsqlproxy-play"
  project       = "battlesnake-io"
}

module "cloudsqlproxy-play-service-account-key" {
  source = "../../../../modules/gcp/service_account_key"

  service_account_id = "${module.cloudsqlproxy-play-service-account.name}"
}

module "cloudsqlproxy-play-binding-cloudsql-client" {
  source                = "../../../../modules/gcp/project_iam_binding"

  project               = "battlesnake-io"

  role                  = "roles/cloudsql.client"
  member                = "serviceAccount:${module.cloudsqlproxy-play-service-account.email}"
}

module "cloudsqlproxy-play-binding-cloudsql-editor" {
  source                = "../../../../modules/gcp/project_iam_binding"
  
  project               = "battlesnake-io"

  role                  = "roles/cloudsql.editor"
  member                = "serviceAccount:${module.cloudsqlproxy-play-service-account.email}"
}

module "cloudsqlproxy-play-binding-cloudsql-admin" {
  source                = "../../../../modules/gcp/project_iam_binding"

  project               = "battlesnake-io"

  role                  = "roles/cloudsql.admin"
  member                = "serviceAccount:${module.cloudsqlproxy-play-service-account.email}"
}

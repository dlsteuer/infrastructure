# Tournmanent db
output "instance_name_engine_tournament" {
  value = "${module.postgresql-engine-tournament.instance_name}"
}
output "instance_address_engine_tournament" {
  value = "${module.postgresql-engine-tournament.instance_address}"
}
output "self_link_engine_tournament" {
  value = "${module.postgresql-engine-tournament.self_link}"
}
output "generated_user_password_engine_tournament" {
  value       = "${module.db-user-engine-tournament.generated_user_password}"
  sensitive   = true
}
output "db_user_name_engine_tournament" {
  value = "${module.db-user-engine-tournament.name}"
}
output "connection_name_engine_tournament" {
  value = "${module.postgresql-engine-tournament.connection_name}"
}
output "cloudsqlproxy-engine-tournament-service-account-id" {
  value = "${module.cloudsqlproxy-engine-tournament-service-account.id}"
}
output "cloudsqlproxy-engine-tournament-service-account-private-key" {
  value       = "${module.cloudsqlproxy-engine-tournament-service-account-key.private_key}"
  sensitive   = true
}

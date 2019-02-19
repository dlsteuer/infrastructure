variable "name" {}
variable "region" {}
variable "project" {}
variable "gke_cluster_name" {}
variable "node_count" {}
variable "min_nodes_version" {}
variable "machine_type" {}
variable "disk_size_gb" {}
variable "tags" {
    type = "list"
}
variable "oauth_scopes" {
    type = "list"
}
variable "auto_repair" {
    default = true
}
variable "preemptible" {
    default = false
}






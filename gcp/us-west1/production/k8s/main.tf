provider "google" {
  region = "us-west1"
}

terraform {
  backend "gcs" {
    bucket = "terraform-battlesnake-io"
    prefix = "battlesnake/k8s"
  }

  required_version = "= 0.11.7"
}

module "k8s" {
  source             = "../../../../modules/gcp/k8s"
  project            = "battlesnake-io"
  region             = "us-west1"
  min_master_version = "1.9.6-gke.1"
  min_nodes_version  = "1.11.2-gke.18"
  machine_type       = "n1-standard-2"
  disk_size_gb       = "64"
  subnetwork_name    = "projects/battlesnake-io/regions/us-west1/subnetworks/battlesnake-private"
  network_name       = "projects/battlesnake-io/global/networks/battlesnake"
}

module "gke_node_pool_001" {
  source            = "../../../../modules/gcp/gke_node_pool"
  name              = "battlesnake-k8s-np-001"
  region            = "us-west1"
  project           = "battlesnake-io"
  gke_cluster_name  = "${module.k8s.cluster_name}"
  node_count        = "2"
  min_nodes_version = "1.11.5-gke.5"
  auto_repair       = "true"
  preemptible       = "false"
  machine_type      = "n1-standard-2"
  disk_size_gb      = "64"
  tags              = [
    "ssh", 
    "k8s-nodes",
  ]
  oauth_scopes      = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/bigquery",
  ]
}

module "gke_node_pool_002" {
  source            = "../../../../modules/gcp/gke_node_pool"
  name              = "battlesnake-k8s-np-002"
  region            = "us-west1"
  project           = "battlesnake-io"
  gke_cluster_name  = "${module.k8s.cluster_name}"
  node_count        = "2"
  min_nodes_version = "1.11.5-gke.5"
  auto_repair       = "true"
  preemptible       = "false"
  machine_type      = "n1-standard-2"
  disk_size_gb      = "64"
  tags              = [
    "ssh", 
    "k8s-nodes",
  ]
  oauth_scopes      = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/bigquery",
  ]
}

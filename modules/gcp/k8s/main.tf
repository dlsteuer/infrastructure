# Generate a random password
resource "random_string" "password" {
  length  = 16
  special = true
  number  = true
  lower   = true
  upper   = true
}

# Creates a regional k8s cluster. A regional cluster will create a master in each zone of the region.
resource "google_container_cluster" "battlesnake-k8s-gke" {
  name               = "battlesnake-k8s-gke"
  region             = "${var.region}"
  project            = "${var.project}"
  min_master_version = "${var.min_master_version}"
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  network            = "${var.network_name}"               # Network created with the network module
  subnetwork         = "${var.subnetwork_name}"            # Subnetwork created with the network module
  initial_node_count = "0"

  # IPs, CIDR blocks allow to connect to the cluster ( kubectl )
  # TODO find a way to pass this as a var 
  master_authorized_networks_config {
    cidr_blocks = {
      cidr_block = "0.0.0.0/0"

      display_name = "All"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  master_auth {
    username = "battlesnake"
    password = "${random_string.password.result}"
  }

  addons_config {
    # Disable dashboard since it is deprecated in GKE
    kubernetes_dashboard {
      disabled = true
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "07:00"
    }
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }
}

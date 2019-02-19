resource "google_container_node_pool" "default" {
  name       = "${var.name}"
  region     = "${var.region}"
  project    = "${var.project}"
  cluster    = "${var.gke_cluster_name}"
  node_count = "${var.node_count}"
  version    = "${var.min_nodes_version}"

  management {
    auto_repair = "${var.auto_repair}"
  }

  node_config {
    preemptible  = "${var.preemptible}"
    machine_type = "${var.machine_type}"
    disk_size_gb = "${var.disk_size_gb}"
    tags         = "${var.tags}"

    oauth_scopes = "${var.oauth_scopes}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create the clusters
# https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#creating_a_cluster_in_your_first_service_project
resource "google_container_cluster" "in_scope" {
  provider                 = google-beta
  name                     = local.in_scope_cluster_name
  location                 = var.region
  project                  = local.project_in_scope
  network                  = google_compute_network.shared-vpc.self_link
  subnetwork               = google_compute_subnetwork.in-scope.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = local.in_scope_pod_ip_range_name
    services_secondary_range_name = local.in_scope_services_ip_range_name
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = local.in_scope_master_ipv4_cidr_block
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.in_scope_master_authorized_networks_config_1_cidr_block
      display_name = local.in_scope_master_authorized_networks_config_1_display_name
    }
  }
}

resource "google_container_node_pool" "in_scope_node_pool" {
  name               = "${local.in_scope_cluster_name}-node-pool"
  location           = var.region
  initial_node_count = local.in_scope_node_pool_initial_node_count
  cluster            = google_container_cluster.in_scope.name
  project            = local.project_in_scope

  autoscaling {
    min_node_count = local.in_scope_node_pool_autoscaling_min_node_count
    max_node_count = local.in_scope_node_pool_autoscaling_max_node_count
  }

  node_config {
    machine_type = local.in_scope_node_pool_machine_type
    oauth_scopes = local.in_scope_node_pool_oauth_scopes
  }
}

resource "google_container_cluster" "out_of_scope" {
  provider                 = google-beta
  name                     = local.out_of_scope_cluster_name
  location                 = var.region
  project                  = local.project_out_of_scope
  network                  = google_compute_network.shared-vpc.self_link
  subnetwork               = google_compute_subnetwork.out-of-scope.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = local.out_of_scope_pod_ip_range_name
    services_secondary_range_name = local.out_of_scope_services_ip_range_name
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = local.out_of_scope_master_ipv4_cidr_block
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.out_of_scope_master_authorized_networks_config_1_cidr_block
      display_name = local.out_of_scope_master_authorized_networks_config_1_display_name
    }
  }
}

resource "google_container_node_pool" "out_of_scope_node_pool" {
  name               = "${local.out_of_scope_cluster_name}-node-pool"
  location           = var.region
  initial_node_count = local.out_of_scope_node_pool_initial_node_count
  cluster            = google_container_cluster.out_of_scope.name
  project            = local.project_out_of_scope

  autoscaling {
    min_node_count = local.out_of_scope_node_pool_autoscaling_min_node_count
    max_node_count = local.out_of_scope_node_pool_autoscaling_max_node_count
  }

  node_config {
    machine_type = local.out_of_scope_node_pool_machine_type
    oauth_scopes = local.out_of_scope_node_pool_oauth_scopes
  }
}

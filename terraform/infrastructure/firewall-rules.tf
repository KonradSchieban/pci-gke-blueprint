# This allows traffic from the in-scope cluster's services to the out-of-scope
# internal load balancer
# the ports are listed in /helm/out-of-scope-microservices/templates/nginx-listener.yaml
resource "google_compute_firewall" "from_out_of_scope_to_in_scope_internal_load_balancer" {
  name          = "from-out-of-scope-to-in-scope-internal-load-balancer"
  project       = local.project_network
  network       = google_compute_network.shared-vpc.name
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["4443-4449"]
  }
}

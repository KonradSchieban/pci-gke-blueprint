# Grant the Host Service Agent User role to the GKE service accounts on the host project
resource "google_project_iam_binding" "host-service-agent-for-gke-service-accounts" {
  project = local.project_network
  role    = "roles/container.hostServiceAgentUser"
  members = [
    "serviceAccount:service-${google_project.in_scope.number}@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:service-${google_project.out_of_scope.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_custom_role" "firewall_admin" {
  depends_on = [google_project.network]
  project    = local.project_network
  role_id    = "firewall_admin"
  title      = "Firewall Admin"

  permissions = [
    "compute.firewalls.create",
    "compute.firewalls.get",
    "compute.firewalls.delete",
    "compute.firewalls.list",
    "compute.firewalls.update",
    "compute.networks.updatePolicy",
  ]
}

# Add the in-scope Kubernetes Engine Service Agent to the above custom role
resource "google_project_iam_member" "add_firewall_admin_to_in_scope_gke_service_account" {
  project = local.project_network
  role    = "projects/${local.project_network}/roles/firewall_admin"
  member  = "serviceAccount:service-${google_project.in_scope.number}@container-engine-robot.iam.gserviceaccount.com"
}

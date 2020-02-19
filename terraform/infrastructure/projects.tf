# Create the projects
resource "google_project" "network" {
  name                = local.project_network
  project_id          = local.project_network
  folder_id           = local.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}
resource "google_project" "in_scope" {
  name                = local.project_in_scope
  project_id          = local.project_in_scope
  folder_id           = local.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}
resource "google_project" "out_of_scope" {
  name                = local.project_out_of_scope
  project_id          = local.project_out_of_scope
  folder_id           = local.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}
resource "google_project" "management" {
  name                = local.project_management
  project_id          = local.project_management
  folder_id           = local.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# Enable GKE API
# https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#enabling_the_api_in_your_projects
resource "google_project_service" "container_api_network" {
  project                    = local.project_network
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "container_api_in" {
  project                    = local.project_in_scope
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "container_api_out" {
  project                    = local.project_out_of_scope
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Enable Stackdriver Trace API
resource "google_project_service" "cloudtrace_api_out_of_scope" {
  project                    = local.project_out_of_scope
  service                    = "cloudtrace.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "monitoring_api_out_of_scope" {
  project                    = local.project_out_of_scope
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "cloudtrace_api_in_scope" {
  project                    = local.project_in_scope
  service                    = "cloudtrace.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "monitoring_api_in_scope" {
  project                    = local.project_in_scope
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
resource "google_project_service" "dns_api_network" {
  project                    = local.project_network
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "terraform_remote_state" "project_network" {
  backend = "gcs"

  config {
    bucket = "${local.remote_state_bucket}"
    prefix = "terraform/state/network"
  }
}

module "project_in_scope" {
  source  = "terraform-google-modules/project-factory/google"
  version = "2.1.1"

  name            = "${local.project_in_scope}"
  org_id          = "${var.org_id}"
  domain          = "${var.domain}"
  billing_account = "${var.billing_account}"
  folder_id       = "${local.folder_id}"

  shared_vpc                  = "${data.terraform_remote_state.project_network.project_id}"
  shared_vpc_subnets          = ["${local.in_scope_subnet_self_link}"]
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudtrace.googleapis.com",
    "logging.googleapis.com",
    "dlp.googleapis.com",
    "clouddebugger.googleapis.com",
  ]
}

data "google_project" "in_scope_google_project" {
  project_id = "${module.project_in_scope.project_id}"
}

# Add this project's Kubernetes Engine Service Agent
# to the custom "Firewall Admin" role managed in the network project
resource "google_project_iam_member" "add_firewall_admin" {
  project = "${data.terraform_remote_state.project_network.project_id}"
  role    = "${data.terraform_remote_state.project_network.firewall_admin_role_id_custom_formatted}"
  member  = "serviceAccount:service-${data.google_project.in_scope_google_project.number}@container-engine-robot.iam.gserviceaccount.com"
}

# Add permissions to write logs to Stackdriver
resource "google_project_iam_binding" "add_stackdriver_write_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/logging.logWriter"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Add permissions to Debug info to Stackdriver
resource "google_project_iam_binding" "add_stackdriver_debugger_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/clouddebugger.agent"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Add permissions to add Trace data
resource "google_project_iam_binding" "add_cloudtrace_agent_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/cloudtrace.agent"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Add permissions to write Metrics
resource "google_project_iam_binding" "add_monitoring_metricwriter_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/monitoring.metricWriter"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Add permissions to view Cloud Storage objects
resource "google_project_iam_binding" "add_storage_objectviewer_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/storage.objectViewer"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Adds the ability to redact content using Data-Loss Prevention API
resource "google_project_iam_binding" "add_dlp_user_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/dlp.user"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Access DLP De-identification Templates
# See <https://cloud.google.com/dlp/docs/concepts-templates>
resource "google_project_iam_binding" "add_dlp_deidentifyTemplatesReader_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/dlp.deidentifyTemplatesReader"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

# Send Profiler data to CloudProfiler
resource "google_project_iam_binding" "add_cloudprofiler_agent_role" {
  project = "${module.project_in_scope.project_id}"
  role    = "roles/cloudprofiler.agent"
  members = ["serviceAccount:${module.project_in_scope.service_account_email}"]
}

output "project_id" {
  value = "${module.project_in_scope.project_id}"
}

output "service_account_email" {
  value = "${module.project_in_scope.service_account_email}"
}

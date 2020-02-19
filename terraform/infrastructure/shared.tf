# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

terraform {
  backend "gcs" {
    bucket = "SETME"
    prefix = "SETME"
  }
}

provider "google" {
  # version = "~> 2.1"
  region = var.region
}
provider "google-beta" {
  # version = "~> 2.1"
  region = var.region
}

variable "billing_account" {
  description = "The ID of the associated billing account"
  default     = ""
}

variable "org_id" {
  description = "The ID of the Google Cloud Organization."
  default     = ""
}

variable "domain" {
  description = "The domain name of the Google Cloud Organization. Use this if you can't add Organization Viewer permissions to your TF ServiceAccount"
  default     = ""
}

variable "folder_id" {
  description = "The ID of the folder in which projects should be created (optional)."
  default     = ""
}

variable "project_prefix" {
  description = "Segment to prefix all project names with."
  default     = "pci-poc"
}

variable "region" {
  default = "us-central1"
}

variable "shared_vpc_name" {
  default     = "shared-vpc"
  description = "The name of the Shared VPC network"
}

# variable "remote_state_bucket" {
#   description = "GCS state bucket"
#   default     = ""
# }

locals {
  project_network      = "${var.project_prefix}-network"
  project_management   = "${var.project_prefix}-management3"
  project_in_scope     = "${var.project_prefix}-in-scope"
  project_out_of_scope = "${var.project_prefix}-out-of-scope"
  folder_id            = "${var.folder_id != "" ? var.folder_id : ""}"

  # in-scope network details
  in_scope_subnet_name = "in-scope"
  in_scope_subnet_cidr = "10.0.4.0/22"

  in_scope_pod_ip_range_name = "in-scope-pod-cidr"
  in_scope_pod_ip_cidr_range = "10.4.0.0/14"

  in_scope_services_ip_range_name = "in-scope-services-cidr"
  in_scope_services_ip_cidr_range = "10.0.32.0/20"

  in_scope_master_ipv4_cidr_block                           = "10.10.11.0/28"
  in_scope_master_authorized_networks_config_1_display_name = "all"
  in_scope_master_authorized_networks_config_1_cidr_block   = "0.0.0.0/0"

  # in-scope cluster details
  in_scope_cluster_name                         = "in-scope"
  in_scope_node_pool_initial_node_count         = 1
  in_scope_node_pool_autoscaling_min_node_count = 1
  in_scope_node_pool_autoscaling_max_node_count = 10
  in_scope_node_pool_machine_type               = "n1-standard-2"
  in_scope_node_pool_oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]

  # out-of-scope network details
  out_of_scope_subnet_name = "out-of-scope"
  out_of_scope_subnet_cidr = "172.16.4.0/22"

  out_of_scope_pod_ip_range_name = "out-of-scope-pod-cidr"
  out_of_scope_pod_ip_cidr_range = "172.20.0.0/14"

  out_of_scope_services_ip_range_name = "out-of-scope-services-cidr"
  out_of_scope_services_ip_cidr_range = "172.16.16.0/20"

  out_of_scope_master_ipv4_cidr_block                           = "10.10.12.0/28"
  out_of_scope_master_authorized_networks_config_1_display_name = "all"
  out_of_scope_master_authorized_networks_config_1_cidr_block   = "0.0.0.0/0"

  # out-of-scope cluster details
  out_of_scope_cluster_name                         = "out-of-scope"
  out_of_scope_node_pool_initial_node_count         = 1
  out_of_scope_node_pool_autoscaling_min_node_count = 1
  out_of_scope_node_pool_autoscaling_max_node_count = 10
  out_of_scope_node_pool_machine_type               = "n1-standard-2"
  out_of_scope_node_pool_oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]

  frontend_external_address_name = "frontend-ext-ip"
  dns_zone_name                  = "SETME"
  dns_zone_dns_name              = "SETME"
  dns_A_record_subdomain         = "store"

}

resource "google_dns_managed_zone" "poc_sandbox_university" {
  project    = local.project_network
  name       = local.dns_zone_name
  dns_name   = local.dns_zone_dns_name
  depends_on = [google_project_service.dns_api_network]
}

resource "google_dns_record_set" "frontend" {
  project      = local.project_network
  name         = "${local.dns_A_record_subdomain}.${google_dns_managed_zone.poc_sandbox_university.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.poc_sandbox_university.name
  rrdatas      = [google_compute_global_address.frontend-ext-ip.address]
}

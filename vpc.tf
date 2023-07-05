# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network-quangbs"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  mtu                     = 1460
  delete_default_routes_on_create = false
}
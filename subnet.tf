resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.2.0.0/16"
  region                   = "asia-southeast1"
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  depends_on               = [google_compute_network.vpc_network]
  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/24"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "public" {
  name                     = "subnet-public"
  ip_cidr_range            = "10.1.0.0/18"
  region                   = "asia-southeast1"
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = false

  depends_on = [google_compute_network.vpc_network]
}

resource "google_compute_router" "router" {
  name = "router"
  region = "asia-southeast1"
  network = google_compute_network.vpc_network.id
}
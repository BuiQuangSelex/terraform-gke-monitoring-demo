resource "google_compute_firewall" "default" {
  name    = "firewall-demo-monitoring"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow_node_exporter" {
  name        = "quangbs-allow-node-exporter"
  network     = google_compute_network.vpc_network.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["quangbs-allow-node-exporter"]
}

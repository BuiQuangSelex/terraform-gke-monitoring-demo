# We create a public IP address for our google compute instance to utilize
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "influxdb_primary" {
  name         = "quangbs-ip-influxdb-primary"
  address_type = "EXTERNAL"
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "influxdb_primary" {
  name                    = "quangbs-influxdb-primary"
  machine_type            = "e2-standard-2"
  zone                    = "asia-southeast1-a"
  metadata_startup_script = file("scripts/influxdb_provisioning.sh")
  tags                    = ["quangbs-allow-node-exporter"]
  metadata = {
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.public.id

    # Associated our public IP address to this instance
    access_config {
      nat_ip = google_compute_address.influxdb_primary.address
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke-demo" {
  name                     = "gke-demo-monitoring"
  location                 = "asia-southeast1-a" # Fixed zone "a" to reduce number of node
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc_network.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  #   node_locations = [
  #     "us-central1-b"
  #   ]

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "iot-platform-333007.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
}


# Creating node pool


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes-demo"
  display_name = "kubernetes-demo"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key
resource "google_service_account_key" "kubernetes" {
  service_account_id = google_service_account.kubernetes.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.gke-demo.id
  node_count = 2

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-standard-4"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.gke-demo.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    labels = {
      team = "devops"
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


locals {
  kubeconfig = {
    apiVersion = "v1"
    kind       = "Config"
    preferences = {
      colors = true
    }
    current-context = google_container_cluster.gke-demo.name
    contexts = [
      {
        name = google_container_cluster.gke-demo.name
        context = {
          cluster   = google_container_cluster.gke-demo.name
          user      = google_service_account.kubernetes.email
          namespace = "default"
        }
      }
    ]
    clusters = [
      {
        name = google_container_cluster.gke-demo.name
        cluster = {
          server                     = "https://${google_container_cluster.gke-demo.endpoint}"
          certificate-authority-data = google_container_cluster.gke-demo.master_auth[0].cluster_ca_certificate
        }
      }
    ]
    users = [
      {
        name = google_service_account.kubernetes.email
        user = {
          exec = {
            apiVersion         = "client.authentication.k8s.io/v1beta1"
            command            = "gke-gcloud-auth-plugin"
            interactiveMode    = "Never"
            provideClusterInfo = true
          }
        }
      }
    ]
  }
}

resource "local_file" "kubeconfig" {
  count = 1
  content  = yamlencode(local.kubeconfig)
  filename = "/home/quangbui/workspace/terraform-gke-monitoring/output/kubeconfig"
}
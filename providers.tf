provider "google" {
  project     = "iot-platform-333007"
  region      = "asia-southeast1"
}

provider "kubernetes" {
  config_path    = "output/kubeconfig"
  config_context = "gke-demo-monitoring"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.71.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }

}


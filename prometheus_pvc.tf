resource "kubernetes_persistent_volume_claim" "pvc_prometheus" {
  metadata {
    name      = "pvc-prometheus"
    namespace = "monitoring"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "30Gi"
      }
    }

    storage_class_name = "standard-rwo"
  }
}


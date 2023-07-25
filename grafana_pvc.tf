resource "kubernetes_persistent_volume_claim" "pvc_grafana" {
  metadata {
    name = "pvc-grafana"
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


resource "kubernetes_service" "jhipster_registry" {
  metadata {
    name      = "jhipster-registry"
    namespace = "iot"

    labels = {
      app = "jhipster-registry"
    }
  }

  depends_on = [ kubernetes_namespace.iot ]

  spec {
    port {
      name = "http"
      port = 8761
    }

    selector = {
      app = "jhipster-registry"
    }

    cluster_ip                  = "None"
    publish_not_ready_addresses = true
  }
}


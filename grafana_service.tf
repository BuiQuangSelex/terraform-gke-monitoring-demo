resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "3000"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 3000
      target_port = "3000"
    }

    selector = {
      app = "grafana"
    }

    type = "LoadBalancer"
  }
}


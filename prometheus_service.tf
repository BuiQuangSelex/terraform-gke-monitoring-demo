resource "kubernetes_service" "prometheus_service" {
  count = 1
  metadata {
    name      = "prometheus-service"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9090"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 8080
      target_port = "9090"
      node_port   = 30000
    }

    selector = {
      app = "prometheus-server"
    }

    type = "NodePort"
  }

  depends_on = [ kubernetes_namespace.monitoring ]
}


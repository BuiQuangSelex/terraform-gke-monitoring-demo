resource "kubernetes_service" "grafana" {
  count = 1
  metadata {
    name      = "grafana"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "3000"

      "prometheus.io/scrape" = "true"
    }
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  spec {
    port {
      port        = 3000
      target_port = "3000"
      node_port   = 32000
    }

    selector = {
      app = "grafana"
    }

    type = "NodePort"
  }
}


resource "kubernetes_service" "node_exporter" {
  count = 1
  metadata {
    name      = "node-exporter"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9100"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "node-exporter"
      protocol    = "TCP"
      port        = 9100
      target_port = "9100"
    }

    selector = {
      "app.kubernetes.io/component" = "exporter"

      "app.kubernetes.io/name" = "node-exporter"
    }
  }
}


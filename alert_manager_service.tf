resource "kubernetes_service" "alertmanager" {
  count = 1
  metadata {
    name      = "alertmanager"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9093"

      "prometheus.io/scrape" = "true"
    }
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  spec {
    port {
      port        = 9093
      target_port = "9093"
    }

    selector = {
      app = "alertmanager"
    }
  }
}


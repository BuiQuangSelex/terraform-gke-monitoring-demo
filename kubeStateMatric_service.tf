resource "kubernetes_service" "kube_state_metrics" {
  count = 1
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/component" = "exporter"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "telemetry"
      port        = 8081
      target_port = "telemetry"
    }

    selector = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }

    cluster_ip = "None"
  }
}


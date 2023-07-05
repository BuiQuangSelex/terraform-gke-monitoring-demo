resource "kubernetes_service_account" "kube_state_metrics" {
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
}


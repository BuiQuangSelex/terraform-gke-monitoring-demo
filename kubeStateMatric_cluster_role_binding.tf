resource "kubernetes_cluster_role_binding" "kube_state_metrics" {
  count = 1
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/component" = "exporter"

      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
}


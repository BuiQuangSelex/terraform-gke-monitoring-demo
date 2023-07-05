resource "kubernetes_cluster_role_binding" "prometheus" {
  count = 1
  metadata {
    name = "prometheus"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "monitoring"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus"
  }

  depends_on = [ kubernetes_namespace.monitoring ]
}


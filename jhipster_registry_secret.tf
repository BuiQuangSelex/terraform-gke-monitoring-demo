resource "kubernetes_secret" "registry_secret" {
  metadata {
    name      = "registry-secret"
    namespace = "iot"
  }

  depends_on = [ kubernetes_namespace.iot ]

  data = {
    registry-admin-password = "admin"
  }

  type = "Opaque"
}


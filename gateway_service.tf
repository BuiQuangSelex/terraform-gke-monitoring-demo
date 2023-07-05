resource "kubernetes_service" "gateway" {
  metadata {
    name      = "gateway"
    namespace = "iot"
  }

  spec {
    port {
      port        = 8080
      target_port = "8080"
      node_port   = 31080
    }

    selector = {
      app = "gateway"
    }

    type = "NodePort"
  }
}


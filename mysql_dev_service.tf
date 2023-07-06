resource "kubernetes_service" "mysql_dev" {
  metadata {
    name      = "mysql-dev"
    namespace = "monitoring"
  }

  spec {
    port {
      name        = "mysqldevexporter"
      protocol    = "TCP"
      port        = 9104
      target_port = "9104"
    }

    selector = {
      app = "mysqldevexporter"
    }
  }
}


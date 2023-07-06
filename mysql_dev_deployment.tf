resource "kubernetes_deployment" "mysql_dev_exporter" {
  metadata {
    name      = "mysql-dev-exporter"
    namespace = "monitoring"
  }

  spec {
    selector {
      match_labels = {
        app = "mysqldevexporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysqldevexporter"
        }
      }

      spec {
        container {
          name  = "mysql-dev-exporter"
          image = "prom/mysqld-exporter:v0.14.0"

          port {
            container_port = 9104
          }

          env {
            name  = "DATA_SOURCE_NAME"
            value = "selex:yq99NPGuUSbHP5bQc7xtdfnvB3qt7WY2@(34.101.221.224:3306)/"
          }

          resources {
            limits = {
              cpu = "250m"

              memory = "180Mi"
            }

            requests = {
              cpu = "102m"

              memory = "180Mi"
            }
          }
        }
      }
    }
  }
}


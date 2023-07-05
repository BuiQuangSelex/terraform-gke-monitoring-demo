resource "kubernetes_deployment" "grafana" {
  count = 1
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        name = "grafana"

        labels = {
          app = "grafana"
        }
      }

      spec {
        volume {
          name      = "grafana-storage"
          empty_dir {}
        }

        volume {
          name = "grafana-datasources"

          config_map {
            name         = "grafana-datasources"
            default_mode = "0644"
          }
        }

        container {
          name  = "grafana"
          image = "grafana/grafana:latest"

          port {
            name           = "grafana"
            container_port = 3000
          }

          resources {
            limits = {
              cpu = "1"

              memory = "1Gi"
            }

            requests = {
              cpu = "500m"

              memory = "500M"
            }
          }

          volume_mount {
            name       = "grafana-storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "grafana-datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
          }
        }
      }
    }
  }
}


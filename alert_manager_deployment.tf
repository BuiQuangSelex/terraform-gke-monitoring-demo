resource "kubernetes_deployment" "alertmanager" {
  count = 1
  metadata {
    name      = "alertmanager"
    namespace = "monitoring"
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "alertmanager"
      }
    }

    template {
      metadata {
        name = "alertmanager"

        labels = {
          app = "alertmanager"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "alertmanager-config"
          }
        }

        volume {
          name = "templates-volume"

          config_map {
            name = "alertmanager-templates"
          }
        }

        volume {
          name      = "alertmanager"
          empty_dir {}
        }

        container {
          name  = "alertmanager"
          image = "prom/alertmanager:v0.25.0"
          args  = ["--config.file=/etc/alertmanager/config.yml", "--storage.path=/alertmanager"]

          port {
            name           = "alertmanager"
            container_port = 9093
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
            name       = "config-volume"
            mount_path = "/etc/alertmanager"
          }

          volume_mount {
            name       = "templates-volume"
            mount_path = "/etc/alertmanager-templates"
          }

          volume_mount {
            name       = "alertmanager"
            mount_path = "/alertmanager"
          }
        }
      }
    }
  }
}


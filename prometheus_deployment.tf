resource "kubernetes_deployment" "prometheus_deployment" {
  metadata {
    name      = "prometheus-deployment"
    namespace = "monitoring"

    labels = {
      app = "prometheus-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus-server"
        }
      }

      spec {
        volume {
          name = "prometheus-config-volume"

          config_map {
            name         = "prometheus-server-conf"
            default_mode = "0644"
          }
        }

        volume {
          name = "prometheus-storage-volume"

          persistent_volume_claim {
            claim_name = "pvc-prometheus"
          }
        }

        container {
          name  = "prometheus"
          image = "prom/prometheus"
          args  = ["--storage.tsdb.retention.time=12h", "--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus/"]

          port {
            container_port = 9090
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
            name       = "prometheus-config-volume"
            mount_path = "/etc/prometheus/"
          }

          volume_mount {
            name       = "prometheus-storage-volume"
            mount_path = "/prometheus/"
          }
        }

        security_context {
          fs_group = 2000
        }
      }
    }
  }
}


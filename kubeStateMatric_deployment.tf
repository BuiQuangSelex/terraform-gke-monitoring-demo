resource "kubernetes_deployment" "kube_state_metrics" {
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

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kube-state-metrics"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "exporter"

          "app.kubernetes.io/name" = "kube-state-metrics"

          "app.kubernetes.io/version" = "2.3.0"
        }
      }

      spec {
        container {
          name  = "kube-state-metrics"
          image = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0"

          port {
            name           = "http-metrics"
            container_port = 8080
          }

          port {
            name           = "telemetry"
            container_port = 8081
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

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "8081"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          security_context {
            run_as_user               = 65534
            read_only_root_filesystem = true
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name            = "kube-state-metrics"
        automount_service_account_token = true
      }
    }
  }
}


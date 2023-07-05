resource "kubernetes_daemonset" "node_exporter" {
  count = 1
  metadata {
    name      = "node-exporter"
    namespace = "monitoring"

    labels = {
      "app.kubernetes.io/component" = "exporter"

      "app.kubernetes.io/name" = "node-exporter"
    }
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "exporter"

        "app.kubernetes.io/name" = "node-exporter"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "exporter"

          "app.kubernetes.io/name" = "node-exporter"
        }
      }

      spec {
        volume {
          name = "sys"

          host_path {
            path = "/sys"
          }
        }

        volume {
          name = "root"

          host_path {
            path = "/"
          }
        }

        container {
          name  = "node-exporter"
          image = "prom/node-exporter"
          args  = ["--path.sysfs=/host/sys", "--path.rootfs=/host/root", "--no-collector.wifi", "--no-collector.hwmon", "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)", "--collector.netclass.ignored-devices=^(veth.*)$"]

          port {
            container_port = 9100
            protocol       = "TCP"
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

          volume_mount {
            name              = "sys"
            read_only         = true
            mount_path        = "/host/sys"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name              = "root"
            read_only         = true
            mount_path        = "/host/root"
            mount_propagation = "HostToContainer"
          }
        }
      }
    }
  }
}


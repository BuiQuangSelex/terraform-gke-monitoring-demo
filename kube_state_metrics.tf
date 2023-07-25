resource "kubernetes_stateful_set" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
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
          "app.kubernetes.io/name" = "kube-state-metrics"

          "app.kubernetes.io/version" = "2.3.0"
        }
      }

      spec {
        container {
          name  = "kube-state-metric"
          image = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0"
          args  = ["--pod=$(POD_NAME)", "--pod-namespace=$(POD_NAMESPACE)", "--port=8080", "--telemetry-port=8081"]

          port {
            name           = "metrics"
            container_port = 8080
          }

          port {
            name           = "metrics-self"
            container_port = 8081
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu = "100m"

              memory = "190Mi"
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
            capabilities {
              drop = ["all"]
            }

            run_as_user  = 1000
            run_as_group = 1000
          }
        }

        service_account_name = "kube-state-metrics"

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/arch"
                  operator = "In"
                  values   = ["arm64", "amd64"]
                }

                match_expressions {
                  key      = "kubernetes.io/os"
                  operator = "In"
                  values   = ["linux"]
                }
              }
            }
          }
        }
      }
    }

    service_name = "kube-state-metrics"
  }
}

resource "kubernetes_service" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }

  spec {
    port {
      name        = "metrics"
      port        = 8080
      target_port = "metrics"
    }

    port {
      name        = "metrics-self"
      port        = 8081
      target_port = "metrics-self"
    }

    selector = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service_account" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }
}

resource "kubernetes_cluster_role_binding" "kube_system_kube_state_metrics" {
  metadata {
    name = "kube-system:kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-system:kube-state-metrics"
  }
}

resource "kubernetes_cluster_role" "kube_system_kube_state_metrics" {
  metadata {
    name = "kube-system:kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "2.3.0"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets", "nodes", "pods", "services", "resourcequotas", "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes", "namespaces", "endpoints"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["statefulsets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}


resource "kubernetes_stateful_set" "jhipster_registry" {
  metadata {
    name      = "jhipster-registry"
    namespace = "iot"
  }

  depends_on = [ kubernetes_namespace.iot, kubernetes_secret.registry_secret ]

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "jhipster-registry"

        version = "1.0"
      }
    }

    template {
      metadata {
        labels = {
          app = "jhipster-registry"

          version = "1.0"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "application-config"
          }
        }

        container {
          name  = "jhipster-registry"
          image = "jhipster/jhipster-registry:v7.4.0"

          port {
            container_port = 8761
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "prod,k8s,api-docs"
          }

          env {
            name = "SPRING_SECURITY_USER_PASSWORD"

            value_from {
              secret_key_ref {
                name = "registry-secret"
                key  = "registry-admin-password"
              }
            }
          }

          env {
            name  = "JHIPSTER_SECURITY_AUTHENTICATION_JWT_BASE64_SECRET"
            value = "YlhrdGMyVmpjbVYwTFhSdmEyVnVMWFJ2TFdOb1lXNW5aUzFwYmkxd2NtOWtkV04wYVc5dUxXRnVaQzEwYnkxclpXVndMV2x1TFdFdGMyVmpkWEpsTFhCc1lXTmwK"
          }

          env {
            name  = "SPRING_CLOUD_CONFIG_SERVER_COMPOSITE_0_TYPE"
            value = "native"
          }

          env {
            name  = "SPRING_CLOUD_CONFIG_SERVER_COMPOSITE_0_SEARCH_LOCATIONS"
            value = "file:./central-config"
          }

          env {
            name  = "EUREKA_INSTANCE_LEASE_RENEWAL_INTERVAL_IN_SECONDS"
            value = "15"
          }

          env {
            name  = "EUREKA_INSTANCE_LEASE_EXPIRATION_DURATION_IN_SECONDS"
            value = "30"
          }

          env {
            name  = "EUREKA_SERVER_PEER_EUREKA_NODES_UPDATE_INTERVAL_MS"
            value = "15000"
          }

          env {
            name  = "EUREKA_SERVER_RENAWAL_THRESHOLD_UPDATE_INTERVAL_MS"
            value = "15000"
          }

          env {
            name  = "EUREKA_SERVER_REGISTRY_SYNC_RETRIES"
            value = "3"
          }

          env {
            name  = "EUREKA_SERVER_ENABLE_SELF_PRESERVATION"
            value = "false"
          }

          env {
            name  = "EUREKA_SERVER_PEER_NODE_CONNECT_TIMEOUT_MS"
            value = "2000"
          }

          env {
            name  = "EUREKA_CLIENT_FETCH_REGISTRY"
            value = "true"
          }

          env {
            name  = "EUREKA_CLIENT_REGISTER_WITH_EUREKA"
            value = "true"
          }

          env {
            name  = "K8S_CONFIG_PATH"
            value = "/central-config/"
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/central-config"
          }
        }

        termination_grace_period_seconds = 10
      }
    }

    service_name = "jhipster-registry"
  }
}


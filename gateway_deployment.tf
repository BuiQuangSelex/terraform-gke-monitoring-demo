resource "kubernetes_deployment" "gateway" {
  metadata {
    name      = "gateway"
    namespace = "iot"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gateway"
      }
    }

    template {
      metadata {
        labels = {
          app = "gateway"
        }
      }

      spec {
        container {
          name  = "gateway"
          image = "buiquang26/gateway:v1.0"

          port {
            name           = "http"
            container_port = 8080
          }

          env {
            name  = "SERVER_PORT"
            value = "8080"
          }

          env {
            name  = "SERVICE_VEHICLE_URL"
            value = "vehicle-service.iot.svc.cluster.local:8081"
          }

          env {
            name  = "SERVICE_BATTERY_URL"
            value = "battery-service.iot.svc.cluster.local:8081"
          }

          env {
            name  = "SERVICE_SUBSCRIPTION_URL"
            value = "subscription-service.iot.svc.cluster.local:8081"
          }

          env {
            name  = "JHIPSTER_CORS_ALLOWED_ORIGINS"
            value = "*"
          }

          env {
            name  = "JHIPSTER_CORS_ALLOWED_METHODS"
            value = "*"
          }

          env {
            name  = "JHIPSTER_CORS_ALLOWED_HEADERS"
            value = "*"
          }

          env {
            name  = "JHIPSTER_CORS_EXPOSED_HEADERS"
            value = "Authorization,Link,X-Total-Count,X-$gatewayApp-alert,X-$gatewayApp-error,X-$gatewayApp-params"
          }

          env {
            name  = "JHIPSTER_CORS_MAX_AGE"
            value = "1800"
          }

          env {
            name  = "SPRING_JPA_SHOW_SQL"
            value = "true"
          }

          env {
            name  = "SPRING_LIQUIBASE_URL"
            value = "jdbc:mysql://34.101.221.224:3306/gateway?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC&createDatabaseIfNotExist=true"
          }

          env {
            name  = "SPRING_LIQUIBASE_USER"
            value = "selex"
          }

          env {
            name  = "SPRING_LIQUIBASE_PASSWORD"
            value = "yq99NPGuUSbHP5bQc7xtdfnvB3qt7WY2"
          }

          env {
            name  = "SPRING_R2DBC_URL"
            value = "r2dbc:mariadb://34.101.221.224:3306/gateway?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=UTC&createDatabaseIfNotExist=true"
          }

          env {
            name  = "SPRING_R2DBC_USERNAME"
            value = "selex"
          }

          env {
            name  = "SPRING_R2DBC_PASSWORD"
            value = "yq99NPGuUSbHP5bQc7xtdfnvB3qt7WY2"
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "prod,api-docs"
          }

          env {
            name  = "SPRING_CLOUD_CONFIG_URI"
            value = "http://admin:$${jhipster.registry.password}@jhipster-registry.iot.svc.cluster.local:8761/config"
          }

          env {
            name = "JHIPSTER_REGISTRY_PASSWORD"

            value_from {
              secret_key_ref {
                name = "registry-secret"
                key  = "registry-admin-password"
              }
            }
          }

          env {
            name  = "EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE"
            value = "http://admin:$${jhipster.registry.password}@jhipster-registry.iot.svc.cluster.local:8761/eureka/"
          }

          env {
            name  = "MANAGEMENT_METRICS_EXPORT_PROMETHEUS_ENABLED"
            value = "true"
          }

          env {
            name  = "SPRING_SLEUTH_PROPAGATION_KEYS"
            value = "x-request-id,x-ot-span-context"
          }

          env {
            name  = "JAVA_OPTS"
            value = " -Xmx256m -Xms256m"
          }

          env {
            name  = "SERVER_SHUTDOWN"
            value = "graceful"
          }

          resources {
            limits = {
              cpu = "1"

              memory = "1Gi"
            }

            requests = {
              cpu = "500m"

              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}


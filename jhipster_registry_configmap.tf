resource "kubernetes_config_map" "application_config" {
  metadata {
    name      = "application-config"
    namespace = "iot"
  }

  depends_on = [ kubernetes_namespace.iot ]

  data = {
    "application.yml" = "configserver:\n  name:  JHipster Registry\n  status: Connected to the JHipster Registry running in Kubernetes\neureka:\n  client:\n    service-url:\n      # This must contain a list of all Eureka server replicas for registry HA to work correctly\n      defaultZone: http://admin:$${jhipster.registry.password}@jhipster-registry-0.jhipster-registry.iot.svc.cluster.local:8761/eureka/,http://admin:$${jhipster.registry.password}@jhipster-registry-1.jhipster-registry.default.svc.cluster.local:8761/eureka/\njhipster:\n  security:\n    authentication:\n      jwt:\n        secret: fb484971f0b079f5769a89374af15e951d0398cc"
  }
}


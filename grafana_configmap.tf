resource "kubernetes_config_map" "grafana_datasources" {
  count = 1
  metadata {
    name      = "grafana-datasources"
    namespace = "monitoring"
  }

  data = {
    "prometheus.yaml" = "{\n    \"apiVersion\": 1,\n    \"datasources\": [\n        {\n           \"access\":\"proxy\",\n            \"editable\": true,\n            \"name\": \"prometheus\",\n            \"orgId\": 1,\n            \"type\": \"prometheus\",\n            \"url\": \"http://prometheus-service.monitoring.svc:8080\",\n            \"version\": 1\n        }\n    ]\n}"
  }

  depends_on = [ kubernetes_namespace.monitoring ]
}


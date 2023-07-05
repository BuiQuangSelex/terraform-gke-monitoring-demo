
# // create prometheus ------------------
# resource "kubernetes_manifest" "prometheus-clusterRole" {
#     manifest = {
#         "apiVersion" = "rbac.authorization.k8s.io/v1"
#         "kind" = "ClusterRole"
#         "metadata" = {
#             "name" = "prometheus"
#         }
#         "rules" = [
#             {
#             "apiGroups" = [
#                 "",
#             ]
#             "resources" = [
#                 "nodes",
#                 "nodes/proxy",
#                 "services",
#                 "endpoints",
#                 "pods",
#             ]
#             "verbs" = [
#                 "get",
#                 "list",
#                 "watch",
#             ]
#             },
#             {
#             "apiGroups" = [
#                 "extensions",
#             ]
#             "resources" = [
#                 "ingresses",
#             ]
#             "verbs" = [
#                 "get",
#                 "list",
#                 "watch",
#             ]
#             },
#             {
#             "nonResourceURLs" = [
#                 "/metrics",
#             ]
#             "verbs" = [
#                 "get",
#             ]
#             },
#         ]
#     }
# }

# resource "kubernetes_manifest" "prometheus-cluster-role-binding" {
#     manifest = {
#         "apiVersion" = "rbac.authorization.k8s.io/v1"
#         "kind" = "ClusterRoleBinding"
#         "metadata" = {
#             "name" = "prometheus"
#         }
#         "roleRef" = {
#             "apiGroup" = "rbac.authorization.k8s.io"
#             "kind" = "ClusterRole"
#             "name" = "prometheus"
#         }
#         "subjects" = [
#             {
#             "kind" = "ServiceAccount"
#             "name" = "default"
#             "namespace" = "monitoring"
#             },
#         ]
#     }
# }

# resource "kubernetes_manifest" "prometheus-configMap" {
#     manifest = {
#     "apiVersion" = "v1"
#     "data" = {
#         "prometheus.rules" = <<-EOT
#     groups:
#     - name: target
#       rules: 
#       - alert: monitor service down
#         expr: up == 0
#         for: 30s
#         labels: 
#           severity: critical
#         annotations:
#           summary: "Monitor service non-operational"
#           description: "Service {{ $labels.instance }} is down."
#     - name: resource node
#       rules: 
#       - alert: Node RAM Usage Hight
#         expr: ((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / (node_memory_MemTotal_bytes) * 100) > 70
#         for: 30s
#         labels: 
#           severity: critical
#         annotations:
#           summary: "Node[instance={{ $labels.instance }}] Ram usage hight {{$value}}%"
#           description: "Node {{ $labels.instance }} Ram usage hight."
#         EOT
#         "prometheus.yml" = <<-EOT
#     global:
#       scrape_interval: 5s
#       evaluation_interval: 5s
#     rule_files:
#       - /etc/prometheus/prometheus.rules
#     alerting:
#       alertmanagers:
#       - scheme: http
#         static_configs:
#         - targets:
#           - "alertmanager.monitoring.svc:9093"
#     scrape_configs:
#       - job_name: 'mysql-server'
#         static_configs:
#           - targets: ['mysql.monitoring.svc.cluster.local:9104']
#       - job_name: 'gateway'
#         scrape_interval: 2s
#         metrics_path: '/management/prometheus'
#         static_configs:
#           - targets: ['gateway.iot.svc.cluster.local:8080']
#       - job_name: 'node-exporter'
#         kubernetes_sd_configs:
#           - role: endpoints
#         relabel_configs:
#         - source_labels: [__meta_kubernetes_endpoints_name]
#           regex: 'node-exporter'
#           action: keep
#       - job_name: 'kubernetes-apiservers'
#         kubernetes_sd_configs:
#         - role: endpoints
#         scheme: https
#         tls_config:
#           ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
#         bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
#         relabel_configs:
#         - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
#           action: keep
#           regex: default;kubernetes;https
#       - job_name: 'kubernetes-nodes'
#         scheme: https
#         tls_config:
#           ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
#         bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
#         kubernetes_sd_configs:
#         - role: node
#         relabel_configs:
#         - action: labelmap
#           regex: __meta_kubernetes_node_label_(.+)
#         - target_label: __address__
#           replacement: kubernetes.default.svc:443
#         - source_labels: [__meta_kubernetes_node_name]
#           regex: (.+)
#           target_label: __metrics_path__
#           replacement: /api/v1/nodes/${1}/proxy/metrics
#       - job_name: 'kubernetes-pods'
#         kubernetes_sd_configs:
#         - role: pod
#         relabel_configs:
#         - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
#           action: keep
#           regex: true
#         - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
#           action: replace
#           target_label: __metrics_path__
#           regex: (.+)
#         - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
#           action: replace
#           regex: ([^:]+)(?::\d+)?;(\d+)
#           replacement: $1:$2
#           target_label: __address__
#         - action: labelmap
#           regex: __meta_kubernetes_pod_label_(.+)
#         - source_labels: [__meta_kubernetes_namespace]
#           action: replace
#           target_label: kubernetes_namespace
#         - source_labels: [__meta_kubernetes_pod_name]
#           action: replace
#           target_label: kubernetes_pod_name
#       - job_name: 'kube-state-metrics'
#         static_configs:
#           - targets: ['kube-state-metrics.kube-system.svc.cluster.local:8080']
#       - job_name: 'kubernetes-cadvisor'
#         scrape_interval: 5s
#         static_configs:
#         - targets: [cadvisor.kube-system.svc.cluster.local:8080]
#       - job_name: 'kubernetes-service-endpoints'
#         kubernetes_sd_configs:
#         - role: endpoints
#         relabel_configs:
#         - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
#           action: keep
#           regex: true
#         - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
#           action: replace
#           target_label: __scheme__
#           regex: (https?)
#         - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
#           action: replace
#           target_label: __metrics_path__
#           regex: (.+)
#         - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
#           action: replace
#           target_label: __address__
#           regex: ([^:]+)(?::\d+)?;(\d+)
#           replacement: $1:$2
#         - action: labelmap
#           regex: __meta_kubernetes_service_label_(.+)
#         - source_labels: [__meta_kubernetes_namespace]
#           action: replace
#           target_label: kubernetes_namespace
#         - source_labels: [__meta_kubernetes_service_name]
#           action: replace
#           target_label: kubernetes_namespace
#         EOT
#         }
#         "kind" = "ConfigMap"
#         "metadata" = {
#             "labels" = {
#             "name" = "prometheus-server-conf"
#             }
#             "name" = "prometheus-server-conf"
#             "namespace" = "monitoring"
#         }
#     }
#     depends_on = [ kubernetes_namespace.monitoring ]
# }

# resource "kubernetes_manifest" "prometheus-deployment" {
#     # count = 1 //count = 0: delete, 1: create
#     depends_on = [ kubernetes_namespace.monitoring ]
#     manifest = {
#         "apiVersion" = "apps/v1"
#         "kind" = "Deployment"
#         "metadata" = {
#             "labels" = {
#             "app" = "prometheus-server"
#             }
#             "name" = "prometheus-deployment"
#             "namespace" = "monitoring"
#         }
#         "spec" = {
#             "replicas" = 1
#             "selector" = {
#             "matchLabels" = {
#                 "app" = "prometheus-server"
#             }
#             }
#             "template" = {
#             "metadata" = {
#                 "labels" = {
#                 "app" = "prometheus-server"
#                 }
#             }
#             "spec" = {
#                 "containers" = [
#                 {
#                     "args" = [
#                     "--storage.tsdb.retention.time=12h",
#                     "--config.file=/etc/prometheus/prometheus.yml",
#                     "--storage.tsdb.path=/prometheus/",
#                     ]
#                     "image" = "prom/prometheus"
#                     "name" = "prometheus"
#                     "ports" = [
#                     {
#                         "containerPort" = 9090
#                     },
#                     ]
#                     "resources" = {
#                     "limits" = {
#                         "cpu" = "1"
#                         "memory" = "1Gi"
#                     }
#                     "requests" = {
#                         "cpu" = "500m"
#                         "memory" = "500M"
#                     }
#                     }
#                     "volumeMounts" = [
#                     {
#                         "mountPath" = "/etc/prometheus/"
#                         "name" = "prometheus-config-volume"
#                     },
#                     {
#                         "mountPath" = "/prometheus/"
#                         "name" = "prometheus-storage-volume"
#                     },
#                     ]
#                 },
#                 ]
#                 "volumes" = [
#                 {
#                     "configMap" = {
#                     "defaultMode" = 420
#                     "name" = "prometheus-server-conf"
#                     }
#                     "name" = "prometheus-config-volume"
#                 },
#                 {
#                     "emptyDir" = {}
#                     "name" = "prometheus-storage-volume"
#                 },
#                 ]
#             }
#             }
#         }
#     }
# }

# resource "kubernetes_manifest" "prometheus-service" {
#   depends_on = [ kubernetes_namespace.monitoring ]
#   manifest = {
#       "apiVersion" = "v1"
#       "kind" = "Service"
#       "metadata" = {
#           "annotations" = {
#           "prometheus.io/port" = "9090"
#           "prometheus.io/scrape" = "true"
#           }
#           "name" = "prometheus-service"
#           "namespace" = "monitoring"
#       }
#       "spec" = {
#           "ports" = [
#           {
#               "port" = 8080
#               "targetPort" = 9090
#           },
#           ]
#           "selector" = {
#           "app" = "prometheus-server"
#           }
#       }
#   }
# }
# //---------------------------------------

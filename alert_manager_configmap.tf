resource "kubernetes_config_map" "alertmanager_config" {
  count = 1
  metadata {
    name      = "alertmanager-config"
    namespace = "monitoring"
  }

  depends_on = [ kubernetes_namespace.monitoring ]

  data = {
    "config.yml" = "global:\ntemplates:\n- '/etc/alertmanager/*.tmpl'\nroute:\n  receiver: alert-emailer\n  group_by: ['alertname', 'priority']\n  group_wait: 10s\n  repeat_interval: 30m\n\nreceivers:\n- name: alert-emailer\n  email_configs:\n    - to: 'quangbui010975@gmail.com'\n      from: 'qaker1035@gmail.com'\n      smarthost: 'smtp.gmail.com:465'\n      auth_username: 'qaker1035@gmail.com'\n      auth_identity: 'qaker1035@gmail.com'\n      auth_password: 'vmsokcociqazwgxs'\n      require_tls: false"
  }
}


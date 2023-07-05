// create namspace
resource "kubernetes_namespace" "monitoring" {
  count = 1
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "iot" {
  count = 1
  metadata {
    name = "iot"
  }
}

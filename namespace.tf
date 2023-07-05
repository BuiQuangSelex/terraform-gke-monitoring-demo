// create namspace
resource "kubernetes_namespace" "monitoring" {
  count = 1
  metadata {
    name = "monitoring"
  }
}

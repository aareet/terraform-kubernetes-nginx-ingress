resource "kubernetes_manifest" "configmap_ingress_nginx_controller" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "data" = null
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/version" = "0.44.0"
        "helm.sh/chart" = "ingress-nginx-3.23.0"
      }
      "name" = "ingress-nginx-controller"
      "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
    }
  }
}

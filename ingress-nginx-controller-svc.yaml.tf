resource "kubernetes_manifest" "service_ingress_nginx_controller" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "annotations" = null
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
    "spec" = {
      "externalTrafficPolicy" = "Local"
      "ports" = [
        {
          "name" = "http"
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = "http"
        },
        {
          "name" = "https"
          "port" = 443
          "protocol" = "TCP"
          "targetPort" = "https"
        },
      ]
      "selector" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name" = "ingress-nginx"
      }
      "type" = "LoadBalancer"
    }
  }
}

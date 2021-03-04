resource "kubernetes_manifest" "service_ingress_nginx_controller_admission" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/version" = "0.44.0"
        "helm.sh/chart" = "ingress-nginx-3.23.0"
      }
      "name" = "ingress-nginx-controller-admission"
      "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
    }
    "spec" = {
      "ports" = [
        {
          "name" = "https-webhook"
          "port" = 443
          "targetPort" = "webhook"
	  "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name" = "ingress-nginx"
      }
      "type" = "ClusterIP"
    }
  }
}

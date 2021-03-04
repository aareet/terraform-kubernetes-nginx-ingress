resource "kubernetes_manifest" "rolebinding_ingress_nginx" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/version" = "0.44.0"
        "helm.sh/chart" = "ingress-nginx-3.23.0"
      }
      "name" = "ingress-nginx"
      "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "ingress-nginx"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "ingress-nginx"
        "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
      },
    ]
  }
}

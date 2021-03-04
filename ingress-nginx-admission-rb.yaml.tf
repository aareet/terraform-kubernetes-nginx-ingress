resource "kubernetes_manifest" "rolebinding_ingress_nginx_admission" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "annotations" = {
        "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
        "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      }
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/version" = "0.44.0"
        "helm.sh/chart" = "ingress-nginx-3.23.0"
      }
      "name" = "ingress-nginx-admission"
      "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "ingress-nginx-admission"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "ingress-nginx-admission"
        "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
      },
    ]
  }
}

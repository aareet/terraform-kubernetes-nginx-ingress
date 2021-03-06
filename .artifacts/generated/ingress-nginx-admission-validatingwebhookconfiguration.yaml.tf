resource "kubernetes_manifest" "validatingwebhookconfiguration_ingress_nginx_admission" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind" = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/version" = "0.44.0"
        "helm.sh/chart" = "ingress-nginx-3.23.0"
      }
      "name" = "ingress-nginx-admission"
      "namespace" = "default"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "ingress-nginx-controller-admission"
            "namespace" = "ingress-nginx"
            "path" = "/networking/v1beta1/ingresses"
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy" = "Equivalent"
        "name" = "validate.nginx.ingress.kubernetes.io"
        "rules" = [
          {
            "apiGroups" = [
              "networking.k8s.io",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "ingresses",
            ]
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}

resource "kubernetes_manifest" "job_ingress_nginx_admission_create" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "batch/v1"
    "kind" = "Job"
    "metadata" = {
      "annotations" = {
        "helm.sh/hook" = "pre-install,pre-upgrade"
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
      "name" = "ingress-nginx-admission-create"
      "namespace" = kubernetes_manifest.namespace_ingress_nginx.object.metadata.name
    }
    "spec" = {
      "template" = {
        "metadata" = {
          "labels" = {
            "app.kubernetes.io/component" = "admission-webhook"
            "app.kubernetes.io/instance" = "ingress-nginx"
            "app.kubernetes.io/managed-by" = "Helm"
            "app.kubernetes.io/name" = "ingress-nginx"
            "app.kubernetes.io/version" = "0.44.0"
            "helm.sh/chart" = "ingress-nginx-3.23.0"
          }
          "name" = "ingress-nginx-admission-create"
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "create",
                "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc",
                "--namespace=$(POD_NAMESPACE)",
                "--secret-name=ingress-nginx-admission",
              ]
              "env" = [
                {
                  "name" = "POD_NAMESPACE"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.namespace"
                    }
                  }
                },
              ]
              "image" = "docker.io/jettech/kube-webhook-certgen:v1.5.1"
              "imagePullPolicy" = "IfNotPresent"
              "name" = "create"
            },
          ]
          "restartPolicy" = "OnFailure"
          "securityContext" = {
            "runAsNonRoot" = true
            "runAsUser" = 2000
          }
          "serviceAccountName" = "ingress-nginx-admission"
        }
      }
    }
  }
}

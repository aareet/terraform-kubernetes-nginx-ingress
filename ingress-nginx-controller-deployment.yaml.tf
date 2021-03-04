resource "kubernetes_manifest" "deployment_ingress_nginx_controller" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
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
      "namespace" = "ingress-nginx"
    }
    "spec" = {
      "minReadySeconds" = 0
      "revisionHistoryLimit" = 10
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/component" = "controller"
          "app.kubernetes.io/instance" = "ingress-nginx"
          "app.kubernetes.io/name" = "ingress-nginx"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app.kubernetes.io/component" = "controller"
            "app.kubernetes.io/instance" = "ingress-nginx"
            "app.kubernetes.io/name" = "ingress-nginx"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "/nginx-ingress-controller",
                "--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller",
                "--election-id=ingress-controller-leader",
                "--ingress-class=nginx",
                "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller",
                "--validating-webhook=:8443",
                "--validating-webhook-certificate=/usr/local/certificates/cert",
                "--validating-webhook-key=/usr/local/certificates/key",
              ]
              "env" = [
                {
                  "name" = "POD_NAME"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.name"
                    }
                  }
                },
                {
                  "name" = "POD_NAMESPACE"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.namespace"
                    }
                  }
                },
                {
                  "name" = "LD_PRELOAD"
                  "value" = "/usr/local/lib/libmimalloc.so"
                },
              ]
              "image" = "k8s.gcr.io/ingress-nginx/controller:v0.44.0@sha256:3dd0fac48073beaca2d67a78c746c7593f9c575168a17139a9955a82c63c4b9a"
              "imagePullPolicy" = "IfNotPresent"
              "lifecycle" = {
                "preStop" = {
                  "exec" = {
                    "command" = [
                      "/wait-shutdown",
                    ]
                  }
                }
              }
              "livenessProbe" = {
                "failureThreshold" = 5
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 10254
                  "scheme" = "HTTP"
                }
                "initialDelaySeconds" = 10
                "periodSeconds" = 10
                "successThreshold" = 1
                "timeoutSeconds" = 1
              }
              "name" = "controller"
              "ports" = [
                {
                  "containerPort" = 80
                  "name" = "http"
                  "protocol" = "TCP"
                },
                {
                  "containerPort" = 443
                  "name" = "https"
                  "protocol" = "TCP"
                },
                {
                  "containerPort" = 8443
                  "name" = "webhook"
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "failureThreshold" = 3
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 10254
                  "scheme" = "HTTP"
                }
                "initialDelaySeconds" = 10
                "periodSeconds" = 10
                "successThreshold" = 1
                "timeoutSeconds" = 1
              }
              "resources" = {
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "90Mi"
                }
              }
              "securityContext" = {
                "allowPrivilegeEscalation" = true
                "capabilities" = {
                  "add" = [
                    "NET_BIND_SERVICE",
                  ]
                  "drop" = [
                    "ALL",
                  ]
                }
                "runAsUser" = 101
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/usr/local/certificates/"
                  "name" = "webhook-cert"
                  "readOnly" = true
                },
              ]
            },
          ]
          "dnsPolicy" = "ClusterFirst"
          "nodeSelector" = {
            "kubernetes.io/os" = "linux"
          }
          "serviceAccountName" = "ingress-nginx"
          "terminationGracePeriodSeconds" = 300
          "volumes" = [
            {
              "name" = "webhook-cert"
              "secret" = {
                "secretName" = "ingress-nginx-admission"
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  chart            = "ingress-nginx"
  name             = "aks-ingress-controller"
  version          = var.chart_version
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  cleanup_on_fail  = true

  values = [
    file("${path.module}/nginx.yaml")
  ]

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = var.public_ip
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}

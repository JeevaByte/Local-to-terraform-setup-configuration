resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "provisionDataStore.cassandra"
    value = "false"
  }

  set {
    name  = "storage.type"
    value = "elasticsearch"
  }

  depends_on = [module.eks]
}

resource "helm_release" "opensearch" {
  name       = "opensearch"
  repository = "https://opensearch-project.github.io/helm-charts"
  chart      = "opensearch"
  namespace  = "logging"
  create_namespace = true

  set {
    name  = "singleNode"
    value = "true"
  }

  depends_on = [module.eks]
}

resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = "logging"
  create_namespace = true

  set {
    name  = "config.outputs"
    value = "[OUTPUT]\n    Name            es\n    Match           *\n    Host            ${helm_release.opensearch.name}-master\n    Port            9200\n    Index           kubernetes_cluster\n    Type            _doc\n    Logstash_Format On\n    Logstash_Prefix kubernetes"
  }

  depends_on = [helm_release.opensearch]
}
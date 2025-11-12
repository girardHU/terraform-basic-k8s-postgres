# Kubernetes resources for PostgreSQL deployment
# This file contains the Kubernetes manifests that will be deployed to the cluster

# Create a namespace
resource "kubernetes_namespace" "db" {
  metadata {
    name = "database"
  }
}

# ConfigMap for PostgreSQL configuration
resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name      = "postgres-config"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  data = {
    POSTGRES_DB       = "mydb"
    POSTGRES_USER     = "myuser"
    PGDATA           = "/var/lib/postgresql/data/pgdata"
    POSTGRES_HOST_AUTH_METHOD = "scram-sha-256"
    POSTGRES_INITDB_ARGS = "--auth-host=scram-sha-256 --auth-local=scram-sha-256"
  }
}

# Secret for postgres password
resource "kubernetes_secret" "pg" {
  metadata {
    name      = "postgres-password"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  data = {
    POSTGRES_PASSWORD = var.postgres_password
  }

  type = "Opaque"
}

# StatefulSet for PostgreSQL
resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.db.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 2
    service_name = "postgres"

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image

          port {
            container_port = 5432
            name          = "postgres"
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.pg.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.postgres_config.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.postgres_config.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "PGDATA"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.postgres_config.metadata[0].name
                key  = "PGDATA"
              }
            }
          }

          volume_mount {
            name       = "pgdata"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }

    # Use volumeClaimTemplates for StatefulSet (creates one PVC per pod)
    volume_claim_template {
      metadata {
        name = "pgdata"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "scw-bssd"
        resources {
          requests = {
            storage = "20Gi"
          }
        }
      }
    }
  }
}

# Service (LoadBalancer) for external access
resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.db.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}

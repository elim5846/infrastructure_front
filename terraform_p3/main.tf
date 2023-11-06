

provider "azurerm" {
    features {}

    // CHANGE TO NOT HAVE IT IN PLAIN TEXT
    subscription_id = "c8962a4f-8a06-4659-becf-5d99fceb5b1d"
}

provider "kubernetes" {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
    password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_resource_group" "aks" {
    name     = "infra_p3"
    location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = "infra_p3_kub_cluster"
    location            = azurerm_resource_group.aks.location
    resource_group_name = azurerm_resource_group.aks.name
    dns_prefix          = "akscluster"

    default_node_pool {
        name       = "default"
        node_count = 1
        vm_size    = "Standard_D2_v2"
    }
    
    identity {
        type = "SystemAssigned"
    }
}

resource "kubernetes_namespace" "application" {
    metadata {
        name = "application"
    }
}



# resource "azurerm_postgresql_server" "postgres_server" {
#     name                = "todo-db"
#     location            = azurerm_resource_group.aks.location
#     resource_group_name = azurerm_resource_group.aks.name

#     administrator_login          = "MyUnknownLogin"
#     administrator_login_password = "P@ssw0rdC0mpl3x"

#     sku_name   = "GP_Gen5_4"
#     version    = "11"
#     storage_mb = 640000

#     backup_retention_days        = 7
#     geo_redundant_backup_enabled = true
#     auto_grow_enabled            = true

#     public_network_access_enabled    = false
#     ssl_enforcement_enabled          = true
#     ssl_minimal_tls_version_enforced = "TLS1_2"
# }

# resource "azurerm_postgresql_database" "postgres_database" {
#     name                = "todo-db"
#     resource_group_name = azurerm_resource_group.aks.name
#     server_name         = azurerm_postgresql_server.postgres_server.name
#     charset             = "UTF8"
#     collation           = "English_United States.1252"
#   }





resource "kubernetes_manifest" "postgres-service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "postgres-service"
      "namespace" = "application"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 5432
          "protocol" = "TCP"
          "targetPort" = 5432
        },
      ]
      "selector" = {
        "app" = "postgres"
      }
      "type" = "ClusterIP"
    }
  }
}



resource "kubernetes_manifest" "postgres-deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "postgres-deployment"
      "namespace" = "application"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "postgres"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "postgres"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "arkhann/epita2024_infra_postgre:latest"
              "name" = "postgres"
              "imagePullPolicy" = "IfNotPresent"
              "ports" = [
                {
                  "containerPort" = 5432
                },
              ]
            },
          ]
          "volumes" = [
            {
              "name" = "postgredb"
              "persistentVolumeClaim" = {
                "claimName" = "postgres-pv-claim"
              }
            },
          ]
        }
      }
    }
  }
}






resource "kubernetes_manifest" "backend-service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "backend-service"
      "namespace" = "application"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 3000
          "protocol" = "TCP"
          "targetPort" = 3000
        },
      ]
      "selector" = {
        "app" = "backend"
      }
      "type" = "ClusterIP"
    }
  }
}




resource "kubernetes_manifest" "backend-deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "backend-deployment"
      "namespace" = "application"
    }
    "spec" = {
      "replicas" = 3
      "selector" = {
        "matchLabels" = {
          "app" = "backend"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "backend"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "POSTGRES_HOST"
                  "value" = "postgres-service"
                }
              ]
              "image" = "arkhann/epita2024_infra_back:latest"
              "name" = "backend"
              "ports" = [
                {
                  "containerPort" = 3000
                },
              ]
            },
          ]
        }
      }
    }
  }
}


resource "kubernetes_manifest" "frontend-service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "frontend-service"
      "namespace" = "application"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = 3000
        },
      ]
      "selector" = {
        "app" = "frontend"
      }
      "type" = "LoadBalancer"
    }
  }
}

resource "kubernetes_manifest" "frontend-deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "frontend-deployment"
      "namespace" = "application"
    }
    "spec" = {
      "replicas" = 3
      "selector" = {
        "matchLabels" = {
          "app" = "frontend"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "frontend"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "NEXT_PUBLIC_NODE_BACK_URL"
                  "value" = "http://backend-service:3000"
                },
              ]
              "image" = "arkhann/epita2024_infra_front:latest"
              "name" = "frontend"
              "ports" = [
                {
                  "containerPort" = 3000
                },
              ]
            },
          ]
        }
      }
    }
  }
}




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

resource "kubernetes_namespace" "frontend" {
    metadata {
        name = "frontend"
    }
}

resource "kubernetes_namespace" "backend" {
    metadata {
        name = "backend"
    }
}


resource "kubernetes_manifest" "backend-service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "backend-service"
      "namespace" = "backend"
    }
    "spec" = {
      "ports" = [
        {
          "port" = 3000
          "protocol" = "TCP"
          "targetPort" = 3001
        },
      ]
      "selector" = {
        "app" = "frontend"
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
      "namespace" = "backend"
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
      "namespace" = "frontend"
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
      "namespace" = "frontend"
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
                  "value" = "backend-service"
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


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_aks" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "aks_vnet" {
  name =  var.aks_vnet_name
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_aks.name
  address_space = [var.aks_vnet_address_space]
}

resource "azurerm_subnet" "aks_subnet" {
  name = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes = [var.aks_subnet_address_prefix]
}

resource "azurerm_subnet" "app_gwsubnet" {
  name = var.gtw_subnet_name
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes = [var.gtw_subnet_address_prefix]
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.aks_cluster_name
  location            = var.aks_cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_name
  kubernetes_version  = var.k8s_version

  node_resource_group = var.resource_group_name

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  dynamic "default_node_pool" {
    for_each = var.node_pools
    iterator = node_pool
    content{
      name                 = node_pool.value.name
      node_count           = node_pool.value.agent_count
      vm_size              = node_pool.value.vm_size
      vnet_subnet_id       = azurerm_virtual_network.aks_subnet_name.akssubnet.id
      type                 = node_pool.value.type
      orchestrator_version = node_pool.value.orchestrator_version
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
    }
  }

}



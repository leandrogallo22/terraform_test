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

resource "azurerm_network_security_group" "network_security_group"{
  name = var.nsg_name
  location = var.nsg_location
  resource_group_name = azurerm_resource_group.rg_aks.name

  dynamic "security_rule"{
    for_each = var.ngs_rules
    content{
      name = security_rule.value["name"]
      priority = security_rule.value["priority"]
      direction = security_rule.value["direction"]
      access = security_rule.value["access"]
      protocol = security_rule.value["protocol"]
      source_port_range = security_rule.value["source_port_range"]
      destination_port_range = security_rule.value["destination_port_range"]
      source_address_prefix = security_rule.value["source_address_prefix"]
      destination_addess_prefix = security_rule.value["destination_addess_prefix"]
    }
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.aks_cluster_name
  location            = var.aks_cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_name
  kubernetes_version  = var.k8s_version

  node_resource_group = var.resource_group_name
  
  default_node_pool {
      name                 = var.default_node_pool.name
      node_count           = var.default_node_pool.node_count
      vm_size              = var.default_node_pool.vm_size
      vnet_subnet_id       = azurerm_subnet.aks_subnet.id
      orchestrator_version  = var.kubernetes_version
      type                 = var.default_node_pool.type
      availability_zones    = var.default_node_pool.zones
      max_pods              = var.default_node_pool.max_pods
      os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
      node_labels           = var.default_node_pool.labels
      node_taints           = var.default_node_pool.taints
      enable_auto_scaling   = var.default_node_pool.cluster_auto_scaling
      min_count             = var.default_node_pool.cluster_auto_scaling_min_count
      max_count             = var.default_node_pool.cluster_auto_scaling_max_count
      enable_node_public_ip = var.default_node_pool.enable_node_public_ip
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
    }
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = var.additional_node_pools
  
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = each.value.node_os == "Windows" ? substr(each.key, 0, 6) : substr(each.key, 0, 12)
  orchestrator_version  = var.k8s_version
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  availability_zones    = each.value.zones
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.node_os
  vnet_subnet_id        = var.vnet_subnet_id
  node_labels           = each.value.labels
  node_taints           = each.value.taints
  enablae_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  enable_node_public_ip = each.value.enable_node_public_ip
}



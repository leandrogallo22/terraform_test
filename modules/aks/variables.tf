variable "resource_group_name" {
  type      = string
  description = "Resource group name for AKS cluster"
}

variable "resource_group_location" {
  type      = string
  description = "Location for resource group for AKS cluster"
}

variable "aks_vnet_name" {
  type      = string
  description = "Vnet name for AKS cluster"
}

variable "aks_subnet_name" {
  type      = string
  description = "AKS subnet name"
}

variable "gtw_subnet_name" {
  type      = string
  description = "AKS subnet name"
}

variable "aks_vnet_address_space" {
  type      = string
  description = "AKS Vnet address space"
}

variable "aks_subnet_address_prefix" {
  type      = string
  description = "AKS subnet address space"
}

variable "gtw_subnet_address_prefix" {
  type      = string
  description = "Gateway subnet space"
}

variable "node_pools" {
  description = "list of node_pools"
  type = list(object({
    name = string
    node_count = string
    vm_size = string
    type = string
    orchestrator_version = string
  }))
}
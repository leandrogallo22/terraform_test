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

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "aks_cluster_name" {
  type      = string
  description = "Cluster name"
}

variable "aks_cluster_location" {
  type      = string
  description = "Cluster location"
}

variable "aks_dns_name" {
  type      = string
  description = "Aks dns name"
}

variable "k8s_version" {
  type      = string
  description = "kubernetes version for cluster"
}

variable "default_node_pool" {
  description = "The object to configure the default node pool with number of worker nodes, worker node VM size and Availability Zones."
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    type                           = string
    zones             = string
    max_pods                       = number
    os_disk_size_gb                = number
    labels                         = map(string)
    taints                         = list(string)
    node_os                        = string
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_node_public_ip = bool
  })
}

variable "additional_node_pools" {
  description = "The map object to configure one or several additional node pools with number of worker nodes, worker node VM size and Availability Zones."
  type = map(object({
    node_count                     = number
    vm_size                        = string
    zones             = string
    max_pods                       = number
    os_disk_size_gb                = number
    labels                         = map(string)
    taints                         = list(string)
    node_os                        = string
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_node_public_ip = bool
    }))
}

variable "nsg_rules" {
  description = "Values for each NSG rule"
  type = list(object({
    name = string
    priority = number
    direction = string
    access = string
    protocol = string
    source_port_range = string
    destinatio_port_range = string
    source_addess_prefix = string
    destination_address_prefix = string
  }))
}

variable "resources" {
  type = map(
    object({
      resource_group_name          = string
      resource_group_location      = string
      resource_group_name_tfsfile  = string
      storage_account_name_tfsfile = string
      container_name_tfsfile       = string
      key_tfsfile                  = string
      aks_vnet_name                = string
      aks_subnet_name              = string
      gtw_subnet_name              = string
      aks_vnet_address_space       = string
      aks_subnet_address_prefix    = string
      gtw_subnet_address_prefix    = string
      aks_cluster_name             = string
      aks_cluster_location         = string
      aks_dns_name                 = string
      k8s_version                  = string
      default_node_pool = object({
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
      additional_node_pools = map(object({
        node_count                     = number
        vm_size                        = string
        zones             = string
        max_pods                       = number
        os_disk_size_gb                = number
        node_os                        = string
        labels                         = map(string)
        taints                         = list(string)
        node_os                        = string
        cluster_auto_scaling           = bool
        cluster_auto_scaling_min_count = number
        cluster_auto_scaling_max_count = number
        enable_node_public_ip = bool
      }))
      nsg_rules = list(object({
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
    })
  )
}

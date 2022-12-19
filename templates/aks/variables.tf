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
      node_pools = list(object({
        name                 = string
        node_count           = string
        vm_size              = string
        type                 = string
        orchestrator_version = string
      }))
    })
  )
}

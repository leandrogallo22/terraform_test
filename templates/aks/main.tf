module "aks_creation" {
  source                    = "../../modules/aks"
  resource_group_name       = var.resources[terraform.workspace].resource_group_name
  resource_group_location   = var.resources[terraform.workspace].resource_group_location
  aks_vnet_name             = var.resources[terraform.workspace].aks_vnet_name
  aks_subnet_name           = var.resources[terraform.workspace].aks_subnet_name
  gtw_subnet_name           = var.resources[terraform.workspace].gtw_subnet_name
  aks_vnet_address_space    = var.resources[terraform.workspace].aks_vnet_address_space
  aks_subnet_address_prefix = var.resources[terraform.workspace].aks_subnet_address_prefix
  gtw_subnet_address_prefix = var.resources[terraform.workspace].gtw_subnet_address_prefix
  node_pools                = var.resources[terraform.workspace].node_pools
}
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
  default_node_pool         = var.resources[terraform.workspace].default_node_pool
  additional_node_pools     = var.resources[terraform.workspace].additional_node_pools
  aks_cluster_name          = var.resources[terraform.workspace].aks_cluster_name
  aks_cluster_location      = var.resources[terraform.workspace].aks_cluster_location
  aks_dns_name              = var.resources[terraform.workspace].aks_dns_name
  k8s_version               = var.resources[terraform.workspace].k8s_version
  nsg_rules                 = var.resources[terraform.workspace].nsg_rules
}
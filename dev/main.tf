provider "azurerm" {
  features {}
}

module "network" {
  # Add //infra-modules/ before the module name
  source        = "git::ssh://git@github.com/abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//infra-modules/networking?ref=main"
  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space
  location      = var.location
  rg_name       = var.resource_group_name
}

module "aks" {
  source       = "git::ssh://git@github.com/abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//infra-modules/aks?ref=main"
  cluster_name = var.cluster_name
  location     = var.location
  rg_name      = var.resource_group_name
  subnet_id    = module.network.aks_subnet_id
  vm_size      = var.aks_vm_size
  node_count   = var.aks_node_count
}

module "acr" {
  source   = "git::ssh://git@github.com/abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//infra-modules/acr?ref=main"
  acr_name = var.acr_name
  location = var.location
  rg_name  = var.resource_group_name
}

module "database" {
  source           = "git::ssh://git@github.com/abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//infra-modules/database?ref=main"
  server_name      = var.sql_server_name
  db_name          = var.sql_db_name
  location         = var.sql_location
  rg_name          = var.resource_group_name
  admin_login      = var.sql_admin_login
  admin_password   = var.sql_admin_password
}

# --- Role Assignments ---

resource "azurerm_role_assignment" "aks_network" {
  scope                = "/subscriptions/5b74fea2-5e51-4af1-b70d-6657c89c1251/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.principal_id
}
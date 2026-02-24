provider "azurerm" {
  features {}
}

module "network" {
  source        = "git::git@github.com:hajatnj/infra-modules.git//networking?ref=v1.0.9"
  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space
  location      = var.location
  rg_name       = var.resource_group_name
}

module "aks" {
  source       = "git::git@github.com:hajatnj/infra-modules.git//aks?ref=v1.0.9"
  cluster_name = var.cluster_name
  location     = var.location
  rg_name       = var.resource_group_name
  subnet_id    = module.network.aks_subnet_id
  vm_size      = var.aks_vm_size
  node_count   = var.aks_node_count
}

module "acr" {
  source   = "git::git@github.com:hajatnj/infra-modules.git//acr?ref=v1.0.9"
  acr_name = var.acr_name
  location = var.location
  rg_name  = var.resource_group_name
}

module "database" {
  source         = "git::git@github.com:hajatnj/infra-modules.git//database?ref=v1.0.9"
  server_name    = var.sql_server_name
  db_name        = var.sql_db_name
  location       = var.sql_location
  rg_name        = var.resource_group_name
  admin_login    = var.sql_admin_login
  admin_password = var.sql_admin_password
}

# --- Role Assignments ---

resource "azurerm_role_assignment" "aks_network" {
  scope                = "/subscriptions/ddf38550-6d2b-44b2-b853-bcbe2eb8c2b5/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.principal_id
}

provider "azurerm" {
  features {}
}

module "network" {
  # Change to your module repo and specify the folder inside it
  source        = "git::git@github.com:abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//networking?ref=main"
  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space
  location      = var.location
  rg_name       = var.resource_group_name
}

module "aks" {
  source       = "git::git@github.com:abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//aks?ref=main"
  cluster_name = var.cluster_name
  # ... (keep other variables as they are)
}

module "acr" {
  source   = "git::git@github.com:abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//acr?ref=main"
  acr_name = var.acr_name
  # ...
}

module "database" {
  source = "git::git@github.com:abhinandan07-nayak/Bcc_Terraform_Infra_Module.git//database?ref=main"
  # ...
}

# --- Role Assignments ---

resource "azurerm_role_assignment" "aks_network" {
  # Updated with your actual subscription ID
  scope                = "/subscriptions/5b74fea2-5e51-4af1-b70d-6657c89c1251/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.principal_id
}
terraform {
  backend "azurerm" {
    resource_group_name  = "Bcc_Poc_RG"
    storage_account_name = "technophilestate2026"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
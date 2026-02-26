terraform {
  backend "azurerm" {
    resource_group_name  = "technophile"
    storage_account_name = "technophile"
    container_name       = "terraform-state"
    key                  = "dev.terraform.tfstate"
  }
}

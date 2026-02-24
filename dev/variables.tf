# Global / Provider Variables
variable "location" {
  type        = string
  description = "The Azure region"
}

variable "resource_group_name" {
  type        = string
}

# Networking Variables
variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

# AKS Variables
variable "cluster_name" {
  type = string
}

variable "aks_vm_size" {
  type = string
}

variable "aks_node_count" {
  type = number
}

# ACR Variables
variable "acr_name" {
  type = string
}

# Database Variables
variable "sql_server_name" {
  type = string
}

variable "sql_db_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

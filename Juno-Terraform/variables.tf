##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "client_secret" {
    description = "Client Secret"
}
 
variable "tenant_id" {
    description = "Tenant ID"
}
 
variable "subscription_id" {
    description = "Subscription ID"
}
 
variable "client_id" {
    description = "Client ID"
}

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "myterraformgroup"
}

variable "location" {
  description = "The region where the Azure Resource is created."
  default     = "West Europe"
}

variable "storage_account_tier" {
  description = "Defines the storage tier. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the replication type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "GRS"
}

variable "sourceBranchName" {
  description = "Build Source Branch Name"
  default     = "dev"
}

variable "allowedhosts" {
  description = "Used for host filtering to bind your app to specific hostnames. The value is a semicolon-delimited list of host names without port numbers."
}

variable "auth0apiIdentifier" {
  description = "Auth0 ApiIdentifier Address"
}

variable "auth0claimsnameidentifier" {
  description = "Auth0 Claims nameidentifier Address"
}

variable "auth0tokenaddress" {
  description = "Auth0 Token Address"
}

variable "cryptography-key" {
  description = "Cryptography key"
}

variable "cryptography-iv" {
  description = "Cryptography IV"
}
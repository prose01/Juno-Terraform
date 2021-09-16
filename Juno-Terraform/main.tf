# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used 
terraform {
  backend "azurerm" {
  }
}

# Configure the Azure provider
provider "azurerm" {
    skip_provider_registration = true
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
    features {}
}

# # Generate random text for a unique name
# resource "random_id" "randomId" {
#     keepers = {
#         # Generate a new ID only when a new resource group is defined
#         resource_group = azurerm_resource_group.juno-group.name
#     }

#     byte_length = 8
# }

# Create resource group
resource "azurerm_resource_group" "juno-group" {
    name     = "Juno-ResourceGroup-${var.sourceBranchName}"
    location = "${var.location}"

    tags = {
        Juno = "${var.sourceBranchName}"
    }
}

# Create app service plan
resource "azurerm_app_service_plan" "juno-plan" {
    name                = "Juno-AppServicePlan-${var.sourceBranchName}"
    location            = azurerm_resource_group.juno-group.location
    resource_group_name = azurerm_resource_group.juno-group.name
    kind                = "Linux"
    reserved            = true
    
    sku {
        tier = "Standard"
        size = "S1"
    }

    tags = {
        Juno = azurerm_resource_group.juno-group.tags.Juno
    }
}

# Create app service
resource "azurerm_app_service" "juno" {
    name                = "Juno-${var.sourceBranchName}"
    location            = azurerm_resource_group.juno-group.location
    resource_group_name = azurerm_resource_group.juno-group.name
    app_service_plan_id = azurerm_app_service_plan.juno-plan.id

    site_config {
        dotnet_framework_version = "v5.0"
        linux_fx_version = "v5.0"
        # remote_debugging_enabled = true
        # remote_debugging_version = "VS2019"
        always_on = "true"
        ftps_state = "FtpsOnly"
        http2_enabled = "true"
        use_32_bit_worker_process = "false"
        min_tls_version = "1.2"
    }

    app_settings = {
        "AllowedHosts" = "${var.allowedhosts}"
        "Mongo_Database" = "Avalon"
        "Auth0_Domain" = "${var.auth0domain}"
        "Auth0_ApiIdentifier" = "${var.auth0apiIdentifier}"
        "Auth0_Claims_nameidentifier" = "${var.auth0claimsnameidentifier}"
        "Auth0_TokenAddress" = "${var.auth0tokenaddress}"
        "Cryptography_Key" = "${var.cryptography-key}"
        "Cryptography_IV" = "${var.cryptography-iv}"
    }

    # connection_string {
    #     name  = "Database"
    #     type  = "SQLServer"
    #     value = "Server=tcp:demosqlserver.database.windows.net,1433;Initial Catalog=demosqldatabase;Persist Security Info=False;User ID=${var.administrator_login};Password=${var.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    # }

    https_only = "true"

    identity {
        type = "SystemAssigned"
    }

    logs {
        http_logs {
            file_system {
                retention_in_mb = 30     # in Megabytes
                retention_in_days = 7 # in days
            }
        }
    }

    tags = {       
        Juno = azurerm_resource_group.juno-group.tags.Juno
    }
}

# Create app service slot
resource "azurerm_app_service_slot" "juno-slot" {
    name                = "Juno-staging-${var.sourceBranchName}"
    location            = azurerm_resource_group.juno-group.location
    resource_group_name = azurerm_resource_group.juno-group.name
    app_service_plan_id = azurerm_app_service_plan.juno-plan.id
    app_service_name    = azurerm_app_service.juno.name

    site_config {
        dotnet_framework_version = "v5.0"
        # remote_debugging_enabled = true
        # remote_debugging_version = "VS2019"
        always_on = "true"
        ftps_state = "FtpsOnly"
        http2_enabled = "true"
        use_32_bit_worker_process = "false"
        min_tls_version = "1.2"
    }

    app_settings = {
        "AllowedHosts" = "${var.allowedhosts}"
        "Mongo_Database" = "Avalon"
        "Auth0_Domain" = "${var.auth0domain}"
        "Auth0_ApiIdentifier" = "${var.auth0apiIdentifier}"
        "Auth0_Claims_nameidentifier" = "${var.auth0claimsnameidentifier}"
        "Auth0_TokenAddress" = "${var.auth0tokenaddress}"
        "Cryptography_Key" = "${var.cryptography-key}"
        "Cryptography_IV" = "${var.cryptography-iv}"
    }

    # connection_string {
    #     name  = "Database"
    #     type  = "SQLServer"
    #     value = "Server=tcp:demosqlserver.database.windows.net,1433;Initial Catalog=demosqldatabase;Persist Security Info=False;User ID=${var.administrator_login};Password=${var.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    # }

    https_only = "true"

    identity {
        type = "SystemAssigned"
    }

    logs {
        http_logs {
            file_system {
                retention_in_mb = 30 # in Megabytes
                retention_in_days = 7 # in days
            }
        }
    }

    tags = {       
        Juno = azurerm_resource_group.juno-group.tags.Juno
    }
}

# # Create application insights. Obs! Not working for Linux!
# resource "azurerm_application_insights" "juno-insights" {
#  name                = "juno-insights"
#  location            = azurerm_resource_group.juno-group.location
#  resource_group_name = azurerm_resource_group.juno-group.name
#  application_type    = "web"
#  disable_ip_masking  = false
#  retention_in_days   = 30

#  tags = {       
#         Juno = azurerm_resource_group.juno-group.tags.Juno
#     }
# }
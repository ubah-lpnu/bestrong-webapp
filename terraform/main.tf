terraform {
  required_version = ">=1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "bestrong-state"
    storage_account_name = "stbestrongeastus001"
    container_name       = "cibestrong001"
    key                  = "terraform.conf.tfstate"
  }
}
locals {
  org_name = "bestrong"
}


resource "azurerm_resource_group" "rg" {
  name     = "${local.org_name}-services-rg"
  location = "East US"
}

resource "azurerm_container_registry" "registry" {
  name                = "${local.org_name}registry" 
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true 
}

resource "azurerm_service_plan" "app_service" {
  name                = "${local.org_name}-appserviceplan"
  location            = azurerm_resource_group.rg.location
  os_type = "Linux"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "web-app" {
    location = azurerm_resource_group.rg.location
    name = "${local.org_name}-web-app"
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id = azurerm_service_plan.app_service.id

    site_config {
        application_stack {
            docker_registry_username = azurerm_container_registry.registry.admin_username
            docker_registry_password = azurerm_container_registry.registry.admin_password
            docker_image_name = var.docker_image_name
            docker_registry_url = "https://${azurerm_container_registry.registry.login_server}"
        }
    }

    identity {
        type = "SystemAssigned"
    }
    app_settings = {
        WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    }
}


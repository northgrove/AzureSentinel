terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}


# create a resource group in active subscription
resource "azurerm_resource_group" "rg-SecurityMonitoring" {
  name     = "rg-SecurityMonitoring"
  location = "norwayeast"
}

# Create a Log analytics Workspace in the resource group
resource "azurerm_log_analytics_workspace" "SecurityMonitoring-la" {
  name                = "la-SecurityMonitoring"
  location            = "${azurerm_resource_group.rg-SecurityMonitoring.location}"
 resource_group_name = "${azurerm_resource_group.rg-SecurityMonitoring.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Activeate Azure Sentinel on the Log Analytics Workspace
resource "azurerm_log_analytics_solution" "la-solution-sentinel" {
  solution_name         = "SecurityInsights"
  location              = "${azurerm_resource_group.rg-SecurityMonitoring.location}"
  resource_group_name   = "${azurerm_resource_group.rg-SecurityMonitoring.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.SecurityMonitoring-la.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.SecurityMonitoring-la.name}"
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# Enable Azure Active Directory Identity protectionconnector
resource "azurerm_sentinel_data_connector_azure_active_directory" "AADidpConnector" {
  name                       = "AADConnector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.AADConnector.id
}

# Enable Azure Security Center connector
resource "azurerm_sentinel_data_connector_azure_security_center" "ASCconnector" {
  name                       = "ASCconnector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.ASCconnector.id
}

# Enable Office365 Connector
resource "azurerm_sentinel_data_connector_office_365" "O365connector" {
  name                       = "O365connector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.O365connector.id
}

# Enable Microsoft 365 ATP Connector 
resource "azurerm_sentinel_data_connector_microsoft_defender_advanced_threat_protection" "M365Dconnector" {
  name                       = "M365Dconnector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.M365Dconnector.id
}

# Enable Microsoft Cloud App Security Connector
resource "azurerm_sentinel_data_connector_microsoft_cloud_app_security" "MCASconnector" {
  name                       = "MCASconnector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.MCASconnector.id
}

# Enable MCAS Connector incidents
resource "azurerm_sentinel_alert_rule_ms_security_incident" "MCASincidents" {
  name                       = "mcas-security-incident-alert-rule"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.SecurityMonitoring-la.id
  product_filter             = "Microsoft Cloud App Security"
  display_name               = "MCAS Security Incidents"
  severity_filter            = ["High","Medium","Low"]
}

# Enable MCAS Connector incidents
resource "azurerm_sentinel_alert_rule_ms_security_incident" "AADidpincidents" {
  name                       = "aadidp-security-incident-alert-rule"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.SecurityMonitoring-la.id
  product_filter             = "Azure Active Directory Identity Protection"
  display_name               = "Azure Active Directory Identity Protection Security Incidents"
  severity_filter            = ["High","Medium","Low"]
}



param guidValue string = newGuid()

@description('Name for the Log Analytics workspace used to aggregate data')
param workspaceName string = 'Abradan-Sentinel-Workspace'

@description('AATP alerts state')
param enableAlerts string = 'Enabled'

@description('Tenand Id')
param tenantId string = '142ecb39-3dfe-4114-91f5-ea68b9b10d9d'





resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: 'rgAbradanSecurityMonitoring'
}

resource SentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' existing = { 
  name: 'SecurityInsights(Abradan-Sentinel-Workspace)'
}

// create log analytics workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}



// Microsoft Defender for Identity connector and incidents
resource AATPConnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: guidValue
  kind: 'AzureAdvancedThreatProtection'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
  }
}

resource MDIIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'MDI Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    productFilter: 'Azure Advanced Threat Protection'
    displayName: 'Create incidents based on Microsoft Defender for Identity alerts'
    alertRuleTemplateName: '40ba9493-4183-4eee-974f-87fe39c8f267'
    description: 'Create incidents based on all alerts generated in Microsoft Defender for Identity'
    enabled: true
  }
}

// Identity protection connector and incidents
resource AADIDportconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'AADIDprotDataConnector'
  kind: 'AzureActiveDirectory'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
  }
}

resource AADIDprotIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'Azure AD Identity Protection Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    enabled: true
    productFilter: 'Azure Active Directory Identity Protection'
    displayName: 'Create incidents based on all alerts generated in Azure Active Directory Identity Protection'
    alertRuleTemplateName: '532c1811-79ee-4d9f-8d4d-6304c840daa1'
    description: 'Create incidents based on all alerts generated in Azure Active Directory Identity Protection'

  }
}

// Office 365 activity connector
resource O365Connector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'Office365DataConnector'
  kind: 'Office365'
  properties: {
    tenantId: tenantId
    dataTypes: {
      exchange: {
        state: enableAlerts
      }
      sharePoint: {
        state: enableAlerts
      }
      teams: {
        state: enableAlerts
      }
    }
  }
}


// Enable Azure Security Center connector and create incidents automaticaly
resource ASCConnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name:  'ASCDataConnector'
  kind: 'AzureSecurityCenter'
  properties: {
     dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
    subscriptionId: subscription().subscriptionId
  }
}

resource ASCIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'ASC Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    enabled: true
    productFilter: 'Azure Security Center'
    displayName: 'Create incidents based on Azure Defender alerts'
    alertRuleTemplateName: '90586451-7ba8-4c1e-9904-7d1b7c3cc4d6'
    description: 'Create incidents based on all alerts generated in Azure Defender'

  }
}



// Enable Defender ATP connector and create incidents automaticaly
resource msATPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'MDATPDataConnector'
  kind: 'MicrosoftDefenderAdvancedThreatProtection'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
  }
}

resource msATPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'MDATP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    displayName: 'Create incidents based on Microsoft Defender for Endpoint alerts'
    productFilter: 'Microsoft Defender Advanced Threat Protection'
    alertRuleTemplateName: '327cd4ed-ca42-454b-887c-54e1c91363c6'
    description: 'Create incidents based on all alerts generated in Microsoft Defender for Endpoint'
    enabled: true
  }
}



// Enable MCAS connector and create incidents automaticaly
resource MCASconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'MCASDataConnector'
  kind: 'MicrosoftCloudAppSecurity'
  properties: {
    dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
    tenantId: tenantId
  }
}
resource MCASIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'MCAS Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    productFilter: 'Microsoft Cloud App Security'
    displayName: 'Create incidents based on Microsoft Cloud App Security alerts'
    alertRuleTemplateName: 'b3cfc7c0-092c-481c-a55b-34a3979758cb'
    description: 'Create incidents based on all alerts generated in Microsoft Cloud App Security'
    enabled: true
  }
}


// Enable Office ATP connector and create incidents automaticaly
resource OATPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'OfficeATP'
  kind: 'OfficeATP'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: enableAlerts
      }
    }
  }
}
resource OATPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: workspace
  name: 'Office ATP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
  properties: {
    productFilter: 'Office 365 Advanced Threat Protection'
    displayName: 'Create incidents based on Microsoft Defender for Office 365 alerts'
    alertRuleTemplateName: 'ee1d718b-9ed9-4a71-90cd-a483a4f008df'
    description: 'Create incidents based on all alerts generated in Microsoft Defender for Office 365'
    enabled: true
  }
}

resource MTPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'MTPDataConnector'
  kind: 'MicrosoftThreatProtection'
  properties: {
    dataTypes: {
      incidents: {
        state: enableAlerts
      }
    }
    tenantId: tenantId
  }
}


resource MSTIConnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: workspace
  name: 'MSTIConnector'
  kind: 'MicrosoftThreatIntelligence'
  properties: {
    dataTypes: {
      bingSafetyPhishingURL: {
        lookbackPeriod: 1
        state: enableAlerts
      }
      microsoftEmergingThreatFeed: {
        lookbackPeriod: 1
        state: enableAlerts
      }
    }
    tenantId: tenantId
  }
}



param workspaceName string = 'Abradan-Sentinel-Workspace'
param location string = resourceGroup().location



// create log analytics workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}

// Enable Sentinel on log analytics WS
resource SentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${workspace.name})'
  location: location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: 'SecurityInsights(${workspace.name})'
    product: 'OMSGallery/SecurityInsights'
    publisher: 'Microsoft'
    promotionCode: ''
  }
}


/**
// create log analytics workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
  
}

// Enable Sentinel on log analytics WS
resource SentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' existing = {
  name: 'SecurityInsights(${workspace.name})'
}
*/


// enable connectors
@description('Exchange state')
param exchangeState string = 'enabled'

@description('SharePoint state')
param sharePointState string = 'enabled'

@description('Teams state')
param teamsState string = 'enabled'

@description('Tenand Id')
param tenantId string = '142ecb39-3dfe-4114-91f5-ea68b9b10d9d'


// Enable Office 365 Connector
param O365Guid string = newGuid()

 //resource O365Connector 'Microsoft.OperationalInsights/workspaces/providers/dataConnectors@2020-01-01' = {
  resource O365Connector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
    scope: SentinelSolution
    name: O365Guid
    kind: 'Office365'
    properties: {
      tenantId: tenantId
      dataTypes: {
        exchange: {
          state: exchangeState
        }
        sharePoint: {
          state: sharePointState
        }
        teams: {
          state: teamsState
        }
      }
    }
  }

/**

// Enable Azure Active Directory Connector
resource AADconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'AADDataConnector'
  kind: 'AzureActiveDirectory'
}

// Enable Azure Security Center connector and create incidents automaticaly
resource ASCConnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name:  '2dd8cb59-ed12-4755-a2bc-356c212fbafc'
  kind: 'AzureSecurityCenter'
}
resource ASCIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: ASCConnector
  name: 'ASC Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}

// Enable Defender ATP connector and create incidents automaticaly
resource msATPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'MDATPDataConnector'
  kind: 'MicrosoftDefenderAdvancedThreatProtection'
}
resource msATPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: msATPconnector
  name: 'MDATP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}

// Enable Microsoft Threat Protection connector and create incidents automaticaly
resource MTPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'MTPDataConnector'
  kind: 'MicrosoftThreatProtection'
}
resource MTPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: MTPconnector
  name: 'MTP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}

// Enable MCAS connector and create incidents automaticaly
resource MCASconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'MCASDataConnector'
  kind: 'MicrosoftCloudAppSecurity'
}
resource MCASIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: MCASconnector
  name: 'MCAS Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}

// Enable Azure ATP connector and create incidents autoamticaly
resource AATPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'AzureAdvancedThreatProtection'
  kind: 'AzureAdvancedThreatProtection'
}
resource AATPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: AATPconnector
  name: 'Azure ATP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}


// Enable Office ATP connector and create incidents automaticaly
resource OATPconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'OfficeATP'
  kind: 'OfficeATP'
}
resource OATPIncidents 'Microsoft.SecurityInsights/alertRules@2021-03-01-preview' = {
  scope: OATPconnector
  name: 'Office ATP Incidents'
  kind: 'MicrosoftSecurityIncidentCreation'
}



// Enable Microsoft Threat Intelligence Connector
resource MTIconnector 'Microsoft.SecurityInsights/dataConnectors@2021-03-01-preview' = {
  scope: SentinelSolution
  name: 'MTI Connector'
  kind: 'MicrosoftThreatIntelligence'
}

*/

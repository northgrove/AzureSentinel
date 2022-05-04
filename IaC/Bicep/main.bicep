targetScope = 'subscription'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rgAbradanSecurityMonitoring'
  location: 'westeurope'
}

module sentinel 'CreateSentinel.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'Abradan_Sentinel'
}


/**
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'rgAbradanSecurityMonitoring'
}

module sentinel 'CreateSentinel.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'Abradan_Sentinel'
}
*/

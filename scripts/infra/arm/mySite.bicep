@description('description')
param appName string

@description('description')
param envName string

@description('ibodev')
param myname string

var siteName = '${myname}${appName}-${envName}-site'
var planName = '${myname}${appName}-${envName}-plan'

resource plan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: planName
  location: resourceGroup().location
  sku: {
    name: 'F1'
    capacity: 1
  }
  tags: {
    displayName: planName
  }
  
}

resource site 'Microsoft.Web/sites@2024-04-01' = {
  name: siteName
  location: resourceGroup().location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${planName}': 'Resource'
    displayName: siteName
  }
  properties: {
    name: siteName
    serverFarmId: plan.id
  }
}

resource siteName_appsettings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: site
  name: 'appsettings'
  tags: {
    displayName: 'config'
  }
  properties: {
    EnvName: 'arm'
    StartPage: 'start.md'
    SCM_DO_BUILD_DURING_DEPLOYMENT: 'True'
  }
}

output siteName string = siteName
output planName string = planName

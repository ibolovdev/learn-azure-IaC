// Main.bicep  
    
targetScope = 'resourceGroup'

param appName string
param envName string
param myname string
 

module mySite 'mySite.bicep' = {
  scope: resourceGroup()
  name: 'mySite-deploy'
  params: {
    appName: appName
    envName: envName
    myname: myname
  }
}

output siteName string = mySite.outputs.siteName
output planName string = mySite.outputs.planName

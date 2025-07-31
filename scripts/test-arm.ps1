# test-arm.ps1

##
az login
az account show -o table

## Set Variables
$creator = "ibodev"
$appName = "azIaC"
$envName = "arm"
$loc = "westus"


$rgName = "rg-$creator-$appName-$envName"

## Create RG
az group create --name $rgName --location $loc --tag "env=$envName" "app=$appName" "createDate=$(Get-Date -Format 'yyyy-MM-dd')"
az group show  -n $rgName  -o table


## Deploy IaC
az deployment group create --what-if -g $rgName --template-file ./scripts/infra/arm/mySite.json

az deployment group create --what-if -g $rgName --template-file ./scripts/infra/arm/mySite.json `
--parameters appName=$appName envName=$envName myname=$creator



az deployment group create -g $rgName --template-file ./scripts/infra/arm/mySite.json `
  --parameters ./scripts/infra/arm/mySite.parameters.json

## Create Template Spec
az ts create --name mySite -g $rgName --template-file ./scripts/infra/arm/mySite.json --version "1.0"
az ts list -o table  

$planName = "$creator-$appName-$envName-plan"
$siteName = "$creator-$appName-$envName-site"

## Use Output
$deploy = az deployment group create -g $rgName --template-file ./scripts/infra/arm/mySite.json `
  --parameters ./scripts/infra/arm/mySite.parameters.json

 $deploy = az deployment group create  -g $rgName --template-file ./scripts/infra/arm/mySite.json `
--parameters appName=$appName envName=$envName myname=$creator

$planName = ($deploy | ConvertFrom-Json).properties.outputs.planName.value
$siteName = ($deploy | ConvertFrom-Json).properties.outputs.siteName.value

cd src/myApp
az webapp up -g $rgName --plan $planName --name $siteName  --launch-browser


##bicep
 
 $deploy = az deployment group create  -g $rgName --template-file ./scripts/infra/arm/mainrg.bicep `
--parameters appName=$appName envName=$envName myname=$creator

$planName = ($deploy | ConvertFrom-Json).properties.outputs.planName.value
$siteName = ($deploy | ConvertFrom-Json).properties.outputs.siteName.value

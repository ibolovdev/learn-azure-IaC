# test-stacks.ps1

az stack group --help

## Set Variables
$creator = "ibodev"
$appName = "azIaC"
$envName = "arm"
$loc = "westus"


$rgName = "rg-$creator-$appName-$envName"

## Create RG
az group create --name $rgName --location $loc --tag "env=$envName" "app=$appName" "createDate=$(Get-Date -Format 'yyyy-MM-dd')"
az group show  -n $rgName  -o table

 

$stack  = "$appName-stack"

az stack group create `
  --name $stack `
   --resource-group $rgName `
  --template-file ./scripts/infra/arm/mainrg.bicep `
  --action-on-unmanage 'detachAll' `
  --deny-settings-mode 'none'


  


# test-stacks.ps1

az stack sub --help

## Set Variables
$appName = "ibodev-learn-azIaC"
$loc = "westus"

$stack  = "$appName-stack"

az stack sub create `
  --name $stack `
  --location $loc `
  --template-file ./scripts/infra/arm/mainrg.bicep `
  --action-on-unmanage 'detachAll' `
  --deny-settings-mode 'none'



  
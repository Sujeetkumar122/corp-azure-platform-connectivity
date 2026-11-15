targetScope = 'subscription'

@description('Name of the resource group')
param name string

@description('Azure region for the resource group')
param location string

@description('Resource tags')
param tags object = {}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: name
  location: location
  tags: tags
}

@description('ID of the created resource group')
output id string = rg.id

@description('Name of the created resource group')
output name string = rg.name

@description('Location of the created resource group')
output location string = rg.location

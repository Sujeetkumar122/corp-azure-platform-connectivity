@description('Name of the Public IP')
param name string

@description('Azure region for the Public IP')
param location string

@description('Allocation method for the IP address')
@allowed([
  'Static'
  'Dynamic'
])
param allocationMethod string = 'Static'

@description('SKU for the Public IP')
param skuName string = 'Standard'

@description('Resource tags')
param tags object = {}

resource pip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  properties: {
    publicIPAllocationMethod: allocationMethod
  }
  tags: tags
}

output id string = pip.id
output ipAddress string = pip.properties.ipAddress
output name string = pip.name

@description('Name of the Virtual Network')
param name string

@description('Azure region for the VNet')
param location string

@description('Address prefixes for the Virtual Network')
param addressPrefixes array

@description('Array of subnet objects: [{ name: "snet-1", prefix: "10.0.1.0/24", nsgId: "..." }]')
param subnets array = []

@description('Resource tags')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        networkSecurityGroup: contains(subnet, 'nsgId') ? {
          id: subnet.nsgId
        } : null
        privateEndpointNetworkPolicies: contains(subnet, 'privateEndpointNetworkPolicies') ? subnet.privateEndpointNetworkPolicies : 'Disabled'
      }
    }]
  }
}

output id string = vnet.id
output name string = vnet.name
output subnets array = [for (subnet, i) in subnets: {
  name: vnet.properties.subnets[i].name
  id: vnet.properties.subnets[i].id
}]

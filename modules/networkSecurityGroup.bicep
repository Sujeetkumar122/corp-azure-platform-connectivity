@description('Name of the Network Security Group')
param name string

@description('Azure region for the NSG')
param location string

@description('Security rules array')
param securityRules array = []

@description('Resource tags')
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: [for rule in securityRules: {
      name: rule.name
      properties: {
        priority: rule.priority
        direction: rule.direction
        access: rule.access
        protocol: rule.protocol
        sourcePortRange: rule.?sourcePortRange ?? '*'
        destinationPortRange: rule.?destinationPortRange ?? '*'
        sourceAddressPrefix: rule.?sourceAddressPrefix ?? '*'
        destinationAddressPrefix: rule.?destinationAddressPrefix ?? '*'
      }
    }]
  }
}

output id string = nsg.id
output name string = nsg.name

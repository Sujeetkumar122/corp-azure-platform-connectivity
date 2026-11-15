@description('Name of the Application Gateway (Front Gate)')
param name string

@description('Azure region for the Application Gateway')
param location string

@description('Application Gateway SKU name')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param skuName string = 'WAF_v2'

@description('Application Gateway SKU tier')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param skuTier string = 'WAF_v2'

@description('Capacity/instance count for the Application Gateway')
param capacity int = 2

@description('Subnet Resource ID dedicated to Application Gateway')
param subnetId string

@description('Public IP Resource ID for frontend configuration')
param publicIpId string

@description('Resource tags')
param tags object = {}

var gatewayIPConfigName = 'appGatewayIpConfig'
var frontendIPConfigName = 'appGatewayFrontendIp'
var frontendPortName = 'appGatewayFrontendPort'
var backendPoolName = 'appGatewayBackendPool'
var backendHttpSettingsName = 'appGatewayBackendHttpSettings'
var httpListenerName = 'appGatewayHttpListener'
var requestRoutingRuleName = 'appGatewayRoutingRule'

resource appGateway 'Microsoft.Network/applicationGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
      tier: skuTier
      capacity: capacity
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIPConfigName
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIPConfigName
        properties: {
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendPortName
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
        properties: {}
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsName
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 30
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', name, frontendIPConfigName)
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', name, frontendPortName)
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: requestRoutingRuleName
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', name, httpListenerName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', name, backendPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', name, backendHttpSettingsName)
          }
          priority: 100
        }
      }
    ]
  }
}

output id string = appGateway.id
output name string = appGateway.name
output backendAddressPoolId string = resourceId('Microsoft.Network/applicationGateways/backendAddressPools', name, backendPoolName)

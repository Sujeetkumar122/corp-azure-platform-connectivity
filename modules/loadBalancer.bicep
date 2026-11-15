@description('Name of the Load Balancer')
param name string

@description('Azure region for the Load Balancer')
param location string

@description('Load Balancer SKU')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Public IP resource ID (for public load balancer)')
param publicIpId string = ''

@description('Subnet resource ID (for internal load balancer)')
param subnetId string = ''

@description('Frontend port')
param frontendPort int = 80

@description('Backend port')
param backendPort int = 80

@description('Health probe port')
param probePort int = 80

@description('Health probe path')
param probePath string = '/health'

@description('Resource tags')
param tags object = {}

var frontendConfigName = 'LoadBalancerFrontend'
var backendPoolName = 'LoadBalancerBackendPool'
var probeName = 'HealthProbe'
var lbRuleName = 'LBRule-HTTP'

var isPublic = !empty(publicIpId)

resource lb 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  tags: tags
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendConfigName
        properties: isPublic ? {
          publicIPAddress: {
            id: publicIpId
          }
        } : {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
      }
    ]
    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Http'
          port: probePort
          requestPath: probePath
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: lbRuleName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', name, frontendConfigName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, backendPoolName)
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', name, probeName)
          }
          protocol: 'Tcp'
          frontendPort: frontendPort
          backendPort: backendPort
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
        }
      }
    ]
  }
}

output id string = lb.id
output name string = lb.name
output backendPoolId string = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', name, backendPoolName)

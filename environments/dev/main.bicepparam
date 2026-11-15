using 'main.bicep'

param environment = 'dev'
param location = 'eastus2'

param vnetName = 'vnet-dev-hub-eastus2-01'
param vnetAddressPrefixes = [
  '10.0.0.0/16'
]

param subnets = [
  {
    name: 'snet-dev-hub-appgw-01'
    prefix: '10.0.1.0/24'
  }
  {
    name: 'snet-dev-hub-shared-01'
    prefix: '10.0.2.0/24'
  }
]

param publicIps = [
  {
    name: 'pip-dev-appgw-eastus2-01'
  }
  {
    name: 'pip-dev-lb-eastus2-01'
  }
]

param tags = {
  Environment: 'dev'
  ManagedBy: 'Bicep'
  Tier: 'Connectivity'
  Project: 'Corporate-Landing-Zone'
}

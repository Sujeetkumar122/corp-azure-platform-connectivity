using 'main.bicep'

param environment = 'prod'
param location = 'eastus2'

param vnetName = 'vnet-prod-hub-eastus2-01'
param vnetAddressPrefixes = [
  '172.16.0.0/16'
]

param subnets = [
  {
    name: 'snet-prod-hub-appgw-01'
    prefix: '172.16.1.0/24'
  }
  {
    name: 'snet-prod-hub-shared-01'
    prefix: '172.16.2.0/24'
  }
]

param publicIps = [
  {
    name: 'pip-prod-appgw-eastus2-01'
  }
  {
    name: 'pip-prod-lb-eastus2-01'
  }
]

param tags = {
  Environment: 'prod'
  ManagedBy: 'Bicep'
  Tier: 'Connectivity'
  Compliance: 'PCI-DSS-HIPAA'
  Project: 'Corporate-Landing-Zone'
}

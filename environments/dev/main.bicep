@description('Target environment name')
param environment string = 'dev'

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Virtual Network configuration')
param vnetName string = 'vnet-${environment}-hub-eastus2-01'
param vnetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Subnet configurations')
param subnets array = [
  {
    name: 'snet-${environment}-hub-appgw-01'
    prefix: '10.0.1.0/24'
  }
  {
    name: 'snet-${environment}-hub-shared-01'
    prefix: '10.0.2.0/24'
  }
]

@description('Public IP configurations')
param publicIps array = [
  {
    name: 'pip-${environment}-appgw-eastus2-01'
  }
  {
    name: 'pip-${environment}-lb-eastus2-01'
  }
]

@description('Common resource tags')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Tier: 'Connectivity'
  Project: 'Corporate-Landing-Zone'
}

// 1. Static Standard Public IPs (App Gateway + LB)
module pips '../../modules/publicIp.bicep' = [for (pip, i) in publicIps: {
  name: 'pip-deploy-${i}'
  params: {
    name: pip.name
    location: location
    skuName: 'Standard'
    allocationMethod: 'Static'
    tags: tags
  }
}]

// 2. Hub Virtual Network
module hubVnet '../../modules/virtualNetwork.bicep' = {
  name: 'vnet-deploy'
  params: {
    name: vnetName
    location: location
    addressPrefixes: vnetAddressPrefixes
    subnets: subnets
    tags: tags
  }
}

// 3. Front Gate / Application Gateway
module appGateway '../../modules/applicationGateway.bicep' = {
  name: 'appgw-deploy'
  params: {
    name: 'appgw-${environment}-hub-01'
    location: location
    skuName: 'Standard_v2'
    skuTier: 'Standard_v2'
    capacity: 2
    subnetId: hubVnet.outputs.subnets[0].id
    publicIpId: pips[0].outputs.id
    tags: tags
  }
}

// 4. Public Load Balancer
module loadBalancer '../../modules/loadBalancer.bicep' = {
  name: 'lb-deploy'
  params: {
    name: 'lb-${environment}-pub-01'
    location: location
    skuName: 'Standard'
    publicIpId: pips[1].outputs.id
    frontendPort: 80
    backendPort: 80
    probePort: 80
    probePath: '/health'
    tags: tags
  }
}

output vnetId string = hubVnet.outputs.id
output appGatewayId string = appGateway.outputs.id
output loadBalancerId string = loadBalancer.outputs.id
output publicIps array = [for (pip, i) in publicIps: {
  name: pip.name
  id: pips[i].outputs.id
  ipAddress: pips[i].outputs.ipAddress
}]

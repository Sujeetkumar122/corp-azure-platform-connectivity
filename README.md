# Corporate Azure Platform Connectivity

## Overview
This repository manages the enterprise **Azure Platform Connectivity** tier within the Cloud Adoption Framework (CAF) Landing Zone. It provides Hub Virtual Networks, Front Gate (Application Gateway with WAF_v2), Public Standard Load Balancers, and Static Public IPs across multi-environment (`dev` and `prod`) stages using pure **Bicep** and automated **Azure DevOps YAML** multi-stage pipelines.

## Repository Architecture
```text
corp-azure-platform-connectivity/
├── .gitignore
├── azure-pipelines.yml             # Multi-stage CI/CD pipeline (Validate, What-If, Dev, Prod)
├── bicepconfig.json                # Enterprise Bicep linter & policy rules
├── README.md                       # Architecture & documentation
├── environments/
│   ├── dev/
│   │   ├── main.bicep              # Development parent orchestrator
│   │   └── main.bicepparam         # Dev typed parameter file
│   └── prod/
│       ├── main.bicep              # Production parent orchestrator (WAF_v2, HA)
│       └── main.bicepparam         # Prod typed parameter file
└── modules/
    ├── applicationGateway.bicep    # Front Gate Application Gateway module
    ├── loadBalancer.bicep          # Public Load Balancer module
    ├── networkSecurityGroup.bicep  # NSG module
    ├── publicIp.bicep              # Static Standard Public IP module
    ├── resourceGroup.bicep         # Resource Group module
    └── virtualNetwork.bicep        # Virtual Network module
```

## Features
- **100% Pure Bicep & YAML**: Zero shell scripts (`.sh` / `.ps1`).
- **Clean Root**: Root contains only `environments/`, `modules/`, `azure-pipelines.yml`, `bicepconfig.json`, `.gitignore`, and `README.md`.
- **WAF Front Gate**: Secure perimeter routing via Azure Application Gateway WAF_v2.
- **Enterprise CI/CD**: Azure DevOps YAML pipeline featuring Linting, What-If predictive analysis, and environment deployment gates.

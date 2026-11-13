# Corporate Azure Platform Connectivity

Enterprise Azure Hub Network & Ingress Tier delivering Application Gateway (Front Gate / WAF v2), Azure Public Load Balancer, and Hub Virtual Network topology.

## 🏗️ Architecture & Topology

- **Hub Virtual Network (`vnet-hub-core`)**: Central connectivity spine.
- **Application Gateway (`appgw-frontgate`)**: Layer 7 edge traffic management, SSL offloading, and WAF inspection.
- **Azure Public Load Balancer (`lb-ingress-core`)**: Layer 4 high-availability ingress.
- **Environment Deployments**:
  - `environments/dev/`: Development connectivity tier.
  - `environments/prod/`: Production connectivity tier.

## 📦 Directory Structure

```
corp-azure-platform-connectivity/
├── .gitignore
├── .tflint.hcl
├── README.md
└── environments/
    ├── dev/
    │   ├── provider.tf
    │   ├── data.tf
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── checks.tf
    │   └── terraform.tfvars
    └── prod/
        ├── provider.tf
        ├── data.tf
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── checks.tf
        └── terraform.tfvars
```

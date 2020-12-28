# terraform-azure-network-spoke
Terraform module to build a spoke network layer in Azure on the hub and spoke model.

## Module examples
Simple example<br>
<pre>
module "network" {
    source                 = "app.terraform.io/ANET/network/azure"
    version                = "1.0.0"

    hub_vnet_name          = "EastUS-MGMT-VNET"
    hub_vnet_rg            = "EastUS-Network-Hub-RG"

    enable_remote_gateways = false

    region                 = "EastUS"
    vnet_cidr              = "10.1.0.0/16"
    
    enable_public_subnet   = true
    public_subnet_name     = "public"
    public_subnet          = "10.1.0.0/24"
    
    app_subnet_name        = "app"
    app_subnet             = "10.1.1.0/24"

    data_subnet_name       = "data"
    data_subnet            = "10.1.2.0/24"
}
</pre><br><br>

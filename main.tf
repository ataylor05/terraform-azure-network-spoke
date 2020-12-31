provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_vnet_rg
}

resource "azurerm_resource_group" "app_network_rg" {
  name     = "${var.environment_tag}-${var.region}-${var.app_name}-Network-RG"
  location = var.region

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_security_group" "vnet_public_nsg" {
  count               = var.enable_public_subnet == true ? 1 : 0
  name                = "${var.environment_tag}-${var.region}-${var.app_name}-Public-Inbound-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.app_network_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name          = "${var.environment_tag}-${var.region}-${var.app_name}-VNET"
  address_space = [var.vnet_cidr]
  location      = var.region
  resource_group_name = azurerm_resource_group.app_network_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route_table" "vnet_route_table" {
  name                          = "${var.environment_tag}-${var.region}-${var.app_name}-RT"
  location                      = var.region
  resource_group_name           = azurerm_resource_group.app_network_rg.name
  disable_bgp_route_propagation = false

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "route_to_internet" {
  count               = var.enable_public_subnet == true ? 1 : 0
  name                = "Internet"
  resource_group_name = azurerm_resource_group.app_network_rg.name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_route" "route_to_local_vnet" {
  name                = "LocalVNET"
  resource_group_name = azurerm_resource_group.app_network_rg.name
  route_table_name    = azurerm_route_table.vnet_route_table.name
  address_prefix      = var.vnet_cidr
  next_hop_type       = "VnetLocal"
}

resource "azurerm_subnet" "public_subnet" {
  count                     = var.enable_public_subnet == true ? 1 : 0
  name                      = var.public_subnet_name
  resource_group_name       = azurerm_resource_group.app_network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.public_subnet]
}

resource "azurerm_subnet_route_table_association" "public_subnet_route_table_association" {
  count          = var.enable_public_subnet == true ? 1 : 0
  subnet_id      = azurerm_subnet.public_subnet[count.index].id
  route_table_id = azurerm_route_table.vnet_route_table.id
  depends_on = [azurerm_subnet.public_subnet]
}

resource "azurerm_subnet" "app_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.app_subnet_name
  resource_group_name       = azurerm_resource_group.app_network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.app_subnet]
}

resource "azurerm_subnet_route_table_association" "app_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_subnet" "data_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.data_subnet_name
  resource_group_name       = azurerm_resource_group.app_network_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = [var.data_subnet]
}

resource "azurerm_subnet_route_table_association" "data_subnet_route_table_association" {
  subnet_id      = azurerm_subnet.data_subnet.id
  route_table_id = azurerm_route_table.vnet_route_table.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "Hub-to-${var.app_name}"
  resource_group_name          = var.hub_vnet_rg
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = var.enable_remote_gateways
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${var.app_name}-to-Hub"
  resource_group_name          = azurerm_resource_group.app_network_rg.name
  virtual_network_name         = azurerm_virtual_network.virtual_network.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.enable_remote_gateways
}

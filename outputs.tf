output "network_rg_name" {
  value = azurerm_resource_group.app_network_rg.name
  description = "Azure Resource Group name for network resources."
}

output "network_rg_id" {
  value = azurerm_resource_group.app_network_rg.id
  description = "Azure Resource Group id for network resources."
}

output "vnet_public_nsg_id" {
  value = azurerm_network_security_group.vnet_public_nsg[*].id
  description = "Azure Network Security Group id for public in-bound traffic."
  depends_on = [azurerm_subnet.public_subnet]
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
  description = "Azure VNET id for network resources."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
  description = "Azure VNET name."
}

output "virtual_network_route_table" {
  value = azurerm_route_table.vnet_route_table.id
  description = "Azure VNET Route Table id."
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet[*].id
  description = "Azure subnet id for the public subnet."
  depends_on = [azurerm_subnet.public_subnet]
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
  description = "Azure subnet id for the app subnet."
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet.id
  description = "Azure subnet id for the data subnet."
}

output "hub_peering_id" {
  value = azurerm_virtual_network_peering.hub_to_spoke.id
  description = "Azure VNET peer id for the hub."
}

output "spoke_peering_id" {
  value = azurerm_virtual_network_peering.spoke_to_hub.id
  description = "Azure VNET peer id for the spoke."
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "ct-app.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_net_link" {
  name                  = "${var.project_name_prefix}VnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                   = "${var.mysql_server_name}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.db_username
  administrator_password = var.db_password
  backup_retention_days  = 15
  delegated_subnet_id    = azurerm_subnet.db_snet.id
  private_dns_zone_id    = azurerm_private_dns_zone.dns_zone.id
  sku_name               = "GP_Standard_D2ds_v4"
  zone = 1
  
  

  high_availability {
    mode = "ZoneRedundant"
    standby_availability_zone = 2
  }

  storage {
    auto_grow_enabled = true
  }
  

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_net_link]
}

resource "azurerm_mysql_flexible_server_configuration" "dbconfig" {
  name                = "require_secure_transport"
  value               = "OFF"
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql_server.fqdn
}
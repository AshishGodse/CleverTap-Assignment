resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.project_name_prefix}lb-pubip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "ashishapp"
}

resource "azurerm_lb" "lb" {
  name                = "${var.project_name_prefix}lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  frontend_ip_configuration {
    name                 = "${var.project_name_prefix}frontend-ip"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_be_addr_pool" {
  name                = "${var.project_name_prefix}backend-pool"
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "lb_be_addr_pool_address" {
  count                = 2
  name                 = "${var.project_name_prefix}backend-address-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be_addr_pool.id
  virtual_network_id   = azurerm_virtual_network.vnet.id
  ip_address = var.private_ips[count.index]
  # ip_address           = element(["10.0.2.5", "10.0.2.6"], count.index)
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = "${var.project_name_prefix}probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "${var.project_name_prefix}lb-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lb_probe.id
}




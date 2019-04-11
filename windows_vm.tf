locals {
  storage_account_base_uri = "${azurerm_storage_account.terravm.primary_blob_endpoint}${azurerm_storage_container.terravm.name}"
}

resource "azurerm_resource_group" "terravm" {
   name         = "${var.ResourceGroup}"
   location     = "${var.location}"
   tags         = "${var.tags}"
}

resource "azurerm_virtual_network" "terravm" {
  name                = "${var.vnetname}"
  address_space       = ["${var.VNetAddressPrefix}"]
  dns_servers         = [ "1.1.1.1", "1.0.0.1" ]
  location            = "${azurerm_resource_group.terravm.location}"
  resource_group_name = "${azurerm_resource_group.terravm.name}"
  tags                = "${azurerm_resource_group.terravm.tags}"
}


resource "azurerm_subnet" "terravm" {
  name                 = "${var.subnetname}"
  resource_group_name  = "${azurerm_resource_group.terravm.name}"
  virtual_network_name = "${azurerm_virtual_network.terravm.name}"
  address_prefix       = "${var.VNetSubnetAddressPrefix}"
}

resource "azurerm_public_ip" "terravm" {
  name                    = "${var.publicIpName}"
  location                = "${azurerm_resource_group.terravm.location}"
  resource_group_name     = "${azurerm_resource_group.terravm.name}"
  tags                    = "${azurerm_resource_group.terravm.tags}"
  allocation_method       = "Static"
  domain_name_label       = "${var.fqdn}"
}

resource "azurerm_network_security_group" "terravm" {
   name = "${var.NetworkSecurityGroup}"
   resource_group_name  = "${azurerm_resource_group.terravm.name}"
   location             = "${azurerm_resource_group.terravm.location}"
   tags                 = "${azurerm_resource_group.terravm.tags}"
}

resource "azurerm_network_security_rule" "AllowHTTP" {
    name = "AllowHTTP"
    resource_group_name         = "${azurerm_resource_group.terravm.name}"
    network_security_group_name = "${azurerm_network_security_group.terravm.name}"

    priority                    = 1020
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 80
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}


resource "azurerm_network_security_rule" "AllowHTTPS" {
    name = "AllowHTTPS"
    resource_group_name         = "${azurerm_resource_group.terravm.name}"
    network_security_group_name = "${azurerm_network_security_group.terravm.name}"

    priority                    = 1021
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 443
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_security_rule" "AllowSQLServer" {
    name = "AllowSQLServer"
    resource_group_name         = "${azurerm_resource_group.terravm.name}"
    network_security_group_name = "${azurerm_network_security_group.terravm.name}"

    priority                    = 1030
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 1443
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_security_rule" "AllowRDP" {
    name = "AllowRDP"
    resource_group_name         = "${azurerm_resource_group.terravm.name}"
    network_security_group_name = "${azurerm_network_security_group.terravm.name}"

    priority                    = 1040
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 3389
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_interface" "terravm" {
  name                  = "${var.InterfaceName}"
  location              = "${azurerm_resource_group.terravm.location}"
  resource_group_name   = "${azurerm_resource_group.terravm.name}"
  tags                  = "${azurerm_resource_group.terravm.tags}"

  ip_configuration {
    name                          = "${azurerm_public_ip.terravm.name}"
    subnet_id                     = "${azurerm_subnet.terravm.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.terravm.id}"
  }
}

resource "azurerm_storage_account" "terravm" {
  name                     = "${var.StorageAccount}"
  resource_group_name      = "${azurerm_resource_group.terravm.name}"
  location                 = "${azurerm_resource_group.terravm.location}"
  tags                     = "${azurerm_resource_group.terravm.tags}"
  account_tier             = "${var.StorageAccountTier}"
  account_replication_type = "${var.StorageAccountRepType}"

  lifecycle = {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "terravm" {
  name                     = "${var.StorageContainer}"
  resource_group_name      = "${azurerm_resource_group.terravm.name}"
  storage_account_name     = "${azurerm_storage_account.terravm.name}"
  container_access_type    = "private"

  lifecycle = {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_machine" "terravm" {
  name                  = "${var.vm}"
  location              = "${azurerm_resource_group.terravm.location}"
  resource_group_name   = "${azurerm_resource_group.terravm.name}"
  vm_size               = "${var.vmsize}"
  network_interface_ids = ["${azurerm_network_interface.terravm.id}"]
  
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.offer}"
    sku       = "${var.sku}"
    version   = "latest"
  }
    
  storage_os_disk {
    name          = "osdisk"
    vhd_uri       = "${local.storage_account_base_uri}/osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  # Optional data disks
  storage_data_disk {
    name          = "datadisk1"
    vhd_uri       = "${local.storage_account_base_uri}/datadisk1.vhd"
    disk_size_gb  = "60"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.LocalAdmin}"
    admin_password = "${var.LocalSrvAccSecret}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }
  tags             = "${azurerm_resource_group.terravm.tags}"
}
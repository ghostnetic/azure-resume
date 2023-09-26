provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "resume_resource_group" {
  name     = "CloudResumeGroup"
  location = "East US"
}

# Public IP Configuration
resource "azurerm_public_ip" "resume_public_ip" {
  name                = "resumePublicIP"
  resource_group_name = azurerm_resource_group.resume_resource_group.name
  location            = azurerm_resource_group.resume_resource_group.location
  allocation_method   = "Dynamic"
}

# Storage Account
resource "azurerm_storage_account" "resume_storage_account" {
  name                     = "resumestorageghostnetic"
  resource_group_name      = azurerm_resource_group.resume_resource_group.name
  location                 = azurerm_resource_group.resume_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  static_website {
    index_document = "index.html"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "resume_vnet" {
  name                = "resumeVnet"
  resource_group_name = azurerm_resource_group.resume_resource_group.name
  location            = azurerm_resource_group.resume_resource_group.location
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "resume_subnet" {
  name                 = "resumeSubnet"
  resource_group_name  = azurerm_resource_group.resume_resource_group.name
  virtual_network_name = azurerm_virtual_network.resume_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network interface
resource "azurerm_network_interface" "resume_nic" {
  name                = "resumeNIC"
  location            = azurerm_resource_group.resume_resource_group.location
  resource_group_name = azurerm_resource_group.resume_resource_group.name

  ip_configuration {
    name                          = "resumeIPConfig"
    subnet_id                     = azurerm_subnet.resume_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.resume_public_ip.id
  }
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "resume_vm" {
  name                = "resumeVM"
  resource_group_name = azurerm_resource_group.resume_resource_group.name
  location            = azurerm_resource_group.resume_resource_group.location
  size                = "Standard_B1s"

  network_interface_ids = [
    azurerm_network_interface.resume_nic.id,
  ]

  admin_username = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/david/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo ufw allow 'Nginx Full'",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]

    connection {
      type        = "ssh"
      host        = azurerm_public_ip.resume_public_ip.ip_address  # changed from self.private_ip_address
      user        = "adminuser"
      private_key = file("C:/Users/david/.ssh/id_rsa")
    }
  }
}

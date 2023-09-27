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

# Network Security Group
resource "azurerm_network_security_group" "resume_nsg" {
  name                = "resumeNSG"
  location            = azurerm_resource_group.resume_resource_group.location
  resource_group_name = azurerm_resource_group.resume_resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
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

resource "azurerm_subnet_network_security_group_association" "resume_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.resume_subnet.id
  network_security_group_id = azurerm_network_security_group.resume_nsg.id
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
      host        = azurerm_public_ip.resume_public_ip.ip_address
      user        = "adminuser"
      private_key = file("C:/Users/david/.ssh/id_rsa")
    }
  }
}
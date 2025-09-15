# Step 1: Provider + Resource Group
# Tell Terraform to use Azure Resource Manager (ARM) provider
provider "azurerm" {
  features {} # required by Terraform
  # subscription_id is set via azure CLI (not hardcoded)
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tf-rg"        # resource group name
  location = "UK South"     # region (London) - closest to me
}


# Step 2: Virtual Network + Subnet
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-vnet"
  address_space       = ["10.0.0.0/16"]     # CIDR range
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet inside the VNet
resource "azurerm_subnet" "subnet" {
  name                 = "tf-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]   # smaller range within VNet
}


# Step 3: Network Security Group (NSG) + Rules
# Create NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "tf-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Allow SSH (port 22) - for demo only
resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Allow HTTP (port 80)- for demo only
resource "azurerm_network_security_rule" "http" {
  name                        = "allow-http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


# Step 4: Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "tf-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"   # required for Standard SKU
  sku                 = "Standard"
}


# Step 5: Network Interface (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "tf-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


# Step 6: Linux Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "tf-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"   # small + cheap VM size
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # Temporary password (not for production!)
  admin_password = "<redacted-for-demo>"    # normally managed via Key Vault or SSH keys
  disable_password_authentication = false   # true if using SSH keys

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "Terraform-Demo"
  }
}
